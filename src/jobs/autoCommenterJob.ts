//src/jobs/autoCommenterJob.ts
// src/jobs/autoCommenterJob.ts
import { PrismaClient, CommentPlatform, CommentStatus } from "@prisma/client";
import { processUserAutoComments } from "../services/autoCommenter";

const prisma = new PrismaClient();
const MIN_CREDITS_REQUIRED = 1;

interface AutoCommenterValidationError {
  userId: string;
  reason: string;
}

async function validateConfig(
  config: any,
): Promise<AutoCommenterValidationError | null> {
  if (!config.user) {
    return {
      userId: config.userId,
      reason: "User not found",
    };
  }

  if (!config.user.credit) {
    return {
      userId: config.userId,
      reason: "Credit system not initialized",
    };
  }

  if (config.user.credit.balance < MIN_CREDITS_REQUIRED) {
    return {
      userId: config.userId,
      reason: "Insufficient credits",
    };
  }

  if (!config.accessToken) {
    return {
      userId: config.userId,
      reason: "Missing access token",
    };
  }

  if (!Array.isArray(config.hashtags) || config.hashtags.length === 0) {
    return {
      userId: config.userId,
      reason: "No hashtags configured",
    };
  }

  if (!Object.values(CommentPlatform).includes(config.platform)) {
    return {
      userId: config.userId,
      reason: "Invalid platform configured",
    };
  }

  if (typeof config.postsPerDay !== "number" || config.postsPerDay <= 0) {
    return {
      userId: config.userId,
      reason: "Invalid posts per day configuration",
    };
  }

  return null;
}

async function logAutoCommenterActivity(
  type: "start" | "complete" | "error" | "skip",
  message: string,
  userId?: string,
  error?: any,
) {
  try {
    await prisma.autoCommenterHistory.create({
      data: {
        configId: userId || "system", // Config ID
        postId: `system_${Date.now()}`, // Required field, using timestamp for system logs
        postUrl: "system", // Required field
        platform: CommentPlatform.LINKEDIN, // Default platform
        commentContent: message,
        status:
          type === "error"
            ? CommentStatus.FAILED
            : type === "complete"
              ? CommentStatus.POSTED
              : CommentStatus.PENDING,
        errorMessage: error ? JSON.stringify(error) : undefined,
        postedAt: type === "complete" ? new Date() : null,
      },
    });

    console.log(
      `[AutoCommenter][${type}]${userId ? `[User: ${userId}]` : ""}: ${message}`,
    );
  } catch (logError) {
    console.error("Failed to log auto commenter activity:", logError);
  }
}

export async function runAutoCommenter() {
  try {
    await logAutoCommenterActivity("start", "Starting auto commenter job");

    const configs = await prisma.autoCommenterConfig.findMany({
      where: {
        isEnabled: true,
      },
      include: {
        user: {
          include: {
            credit: true,
          },
        },
      },
    });

    if (!configs.length) {
      await logAutoCommenterActivity(
        "complete",
        "No active configurations found",
      );
      return;
    }

    await logAutoCommenterActivity(
      "start",
      `Processing ${configs.length} active configurations`,
    );

    const results = {
      processed: 0,
      skipped: 0,
      errors: 0,
      details: [] as { userId: string; status: string; reason?: string }[],
    };

    for (const config of configs) {
      try {
        const validationError = await validateConfig(config);

        if (validationError) {
          results.skipped++;
          results.details.push({
            userId: validationError.userId,
            status: "skipped",
            reason: validationError.reason,
          });

          await logAutoCommenterActivity(
            "skip",
            validationError.reason,
            config.userId,
          );
          continue;
        }

        await processUserAutoComments(config);

        results.processed++;
        results.details.push({
          userId: config.userId,
          status: "processed",
        });

        await logAutoCommenterActivity(
          "complete",
          "Successfully processed user configuration",
          config.userId,
        );

        await new Promise((resolve) => setTimeout(resolve, 1000));
      } catch (error) {
        results.errors++;
        results.details.push({
          userId: config.userId,
          status: "error",
          reason: error instanceof Error ? error.message : "Unknown error",
        });

        await logAutoCommenterActivity(
          "error",
          "Failed to process user configuration",
          config.userId,
          error,
        );
      }
    }

    await logAutoCommenterActivity(
      "complete",
      `Auto commenter job completed. Processed: ${results.processed}, Skipped: ${results.skipped}, Errors: ${results.errors}`,
    );

    return results;
  } catch (error) {
    await logAutoCommenterActivity(
      "error",
      "Auto commenter job failed",
      undefined,
      error,
    );
    throw error;
  }
}
