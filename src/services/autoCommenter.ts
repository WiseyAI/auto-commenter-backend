// src/services/autoCommenter.ts
import { PrismaClient, CommentStatus } from "@prisma/client";
import { processLinkedinPost } from "./linkedin";
import { decrypt } from "./encryption";
import { getSpecificColumnData } from "./sheetData";
import type { ColumnResponse, ProcessResult } from "../types";

const prisma = new PrismaClient();
const MAX_DAILY_COMMENTS = 10;

async function getHashtagPosts(hashtag: string): Promise<string[]> {
  const sheetId = process.env.PUBLISHED_SHEET_ID;
  if (!sheetId) {
    throw new Error("Sheet ID not configured");
  }

  const response = await getSpecificColumnData(sheetId, hashtag.toLowerCase());

  // Ensure the response matches the expected type
  const columnResponse = response as ColumnResponse;

  if (!columnResponse.success || !columnResponse.data) {
    console.error(
      `Failed to fetch posts for hashtag: ${hashtag}`,
      columnResponse.error,
    );
    return [];
  }

  // Ensure we're returning an array of strings
  return Array.isArray(columnResponse.data) ? columnResponse.data : [];
}

async function processCommentResult(result: ProcessResult, config: any) {
  console.log("result for logs", result);
  try {
    await prisma.$transaction(async (tx) => {
      // Create history entry
      const history = await tx.autoCommenterHistory.create({
        data: {
          configId: config.id,
          postId: result.postUrn,
          postContent: result.postContent,
          authorName: result.authorName,
          platform: config.platform,
          postUrl: result.postUrl || "",
          commentContent: result.comment,
          status:
            result.status === "success"
              ? CommentStatus.POSTED
              : CommentStatus.FAILED,
          postedAt: result.status === "success" ? new Date() : null,
          errorMessage: result.error,
        },
      });
      return history;
    });
  } catch (error) {
    console.error(`Error processing comment result:`, error);
    throw error;
  }
}

export async function processUserAutoComments(config: any) {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Check daily limit
    const commentCount = await prisma.autoCommenterHistory.count({
      where: {
        configId: config.id,
        status: CommentStatus.POSTED,
        createdAt: { gte: today },
      },
    });

    if (commentCount >= MAX_DAILY_COMMENTS) {
      console.log(`Daily limit reached for user ${config.userId}`);
      return;
    }

    for (const hashtag of config.hashtags) {
      try {
        const postUrls = await getHashtagPosts(hashtag);

        if (!postUrls.length) {
          console.log(`No posts found for hashtag ${hashtag}`);
          continue;
        }

        const decryptedToken = decrypt(config.accessToken);
        const results = await processLinkedinPost(postUrls, decryptedToken);

        for (const result of results) {
          await processCommentResult(result, config);
        }

        // Add small delay between hashtags to prevent rate limiting
        await new Promise((resolve) => setTimeout(resolve, 1000));
      } catch (error) {
        console.error(`Error processing hashtag ${hashtag}:`, error);
      }
    }
  } catch (error) {
    console.error(`Error processing user ${config.userId}:`, error);
  }
}
