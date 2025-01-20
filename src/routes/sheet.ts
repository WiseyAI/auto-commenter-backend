// src/routes/sheetRoutes.ts

import { Router } from "express";
import { asyncHandler } from "../middleware/asyncHandler";
import { getAllSheetData, getSpecificColumnData } from "../services/sheetData";

const router = Router();
const sheetId = process.env.PUBLISHED_SHEET_ID || "";

// Get all sheet data
router.get(
  "/sheet",
  asyncHandler(async (req, res) => {
    const result = await getAllSheetData(sheetId);

    if (!result.success) {
      res.status(500).json(result);
      return;
    }

    res.json(result);
  }),
);

// Get specific column data
router.get(
  "/sheet/column/:columnName",
  asyncHandler(async (req, res) => {
    const { columnName } = req.params;
    const result = await getSpecificColumnData(sheetId, columnName);

    if (!result.success) {
      res.status(404).json(result);
      return;
    }

    res.json(result);
  }),
);

export default router;
