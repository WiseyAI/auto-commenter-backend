// src/routes/comment.ts
import express, { type Request, type Response } from "express";
import { processLinkedinPost } from "../services/linkedin";
import { decrypt } from "../services/encryption";
import { asyncHandler } from "../middleware/asyncHandler";
import { getPostContent } from "../jobs/fetchPosts";
import { generateComment } from "../jobs/generateComment";
import { getSpecificColumnData } from "../services/sheetData";

const router = express.Router();
const sheetId = process.env.PUBLISHED_SHEET_ID || "";

router.post(
  "/comment",
  asyncHandler(async (req: Request, res: Response) => {
    try {
      const columnResponse = await getSpecificColumnData(sheetId, "trending");
      const accessToken = process.env.TEST_ACCESS_TOKEN;

      // First check if the column data was successfully fetched
      if (!columnResponse.success || !columnResponse.data) {
        return res.status(400).json({
          error:
            columnResponse.error || "Failed to fetch technology column data",
        });
      }

      // Now we know data exists and is the column data
      const postUrls = columnResponse.data as string[];

      // Validate input
      if (!Array.isArray(postUrls) || postUrls.length === 0 || !accessToken) {
        return res.status(400).json({
          error: "Missing required parameters or invalid postUrls format",
        });
      }

      const decryptedAccessToken = decrypt(accessToken);

      // Process all URLs at once since processLinkedinPost now handles arrays
      try {
        const results = await processLinkedinPost(
          postUrls,
          decryptedAccessToken,
        );

        res.json({
          success: true,
          processed: results.filter((r) => r.status === "success"),
          errors: results.filter((r) => r.status === "error"),
        });
      } catch (error) {
        res.status(500).json({
          success: false,
          error: error instanceof Error ? error.message : "Processing error",
        });
      }
    } catch (error) {
      console.error("Error:", error);
      res.status(500).json({
        error: error instanceof Error ? error.message : "Internal server error",
      });
    }
  }),
);

// router.post(
//   "/post/test",
//   asyncHandler(async (req: Request, res: Response) => {
//     try {
//       const { postUrl } = req.body;
//       const accessToken = process.env.BRIGHT_DATA_TOKEN!;
//       if (!postUrl || !accessToken) {
//         return res.status(400).json({ error: "Missing required parameters" });
//       }

//       const post = await getPostContent(postUrl);
//       const comment = await generateComment(post);

//       res.json({
//         success: true,
//         comment,
//       });
//     } catch (error) {
//       console.error("Error:", error);
//       res.status(500).json({
//         error: error instanceof Error ? error.message : "Internal server error",
//       });
//     }
//   }),
// );

export default router;
