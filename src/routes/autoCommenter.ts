//src/routes/autoCommenter.ts
import express from "express";
import { runAutoCommenter } from "../jobs/autoCommenterJob";
import { asyncHandler } from "../middleware/asyncHandler";

const router = express.Router();

router.post("/run", async (req, res) => {
  try {
    // Start the job
    const results = await runAutoCommenter();

    res.json({
      success: true,
      message: "Auto commenter job completed successfully",
      results,
    });
  } catch (error) {
    console.error("Error running auto commenter:", error);
    res.status(500).json({
      success: false,
      error: error instanceof Error ? error.message : "Internal server error",
    });
  }
});
export default router;
