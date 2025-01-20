import { Router } from "express";
import { parse } from "csv-parse";

const router = Router();

router.get("/sheet", async (req, res) => {
  try {
    const sheetId = process.env.PUBLISHED_SHEET_ID;

    // Add validation for sheet ID
    if (!sheetId) {
      throw new Error("Sheet ID is not defined in environment variables");
    }

    const sheetNumber = 1;
    const url = `https://docs.google.com/spreadsheets/d/${sheetId}/export?format=csv&gid=${sheetNumber - 1}`;

    // Log the URL for debugging (remove in production)
    console.log("Attempting to fetch from URL:", url);

    const response = await fetch(url);

    // Add more detailed error logging
    if (!response.ok) {
      console.error("Response details:", {
        status: response.status,
        statusText: response.statusText,
        url: response.url,
      });

      // Try to get error details from response
      const errorText = await response.text();
      console.error("Response body:", errorText);

      throw new Error(
        `HTTP error! status: ${response.status}, statusText: ${response.statusText}`,
      );
    }

    const csvData = await response.text();

    // Validate CSV data
    if (!csvData || csvData.trim().length === 0) {
      throw new Error("Received empty CSV data");
    }

    // Log first few characters of CSV (remove in production)
    console.log("First 100 characters of CSV:", csvData.substring(0, 100));

    const records = [];
    const parser = parse(csvData, {
      columns: true,
      skip_empty_lines: true,
      trim: true,
    });

    for await (const record of parser) {
      records.push(record);
    }

    res.json({
      success: true,
      data: records,
      totalRows: records.length,
    });
  } catch (error: any) {
    console.error("Error fetching Google Sheet:", error);
    res.status(500).json({
      success: false,
      error: error.message || "Failed to fetch sheet data",
      details:
        process.env.NODE_ENV === "development"
          ? {
              sheetId: process.env.PUBLISHED_SHEET_ID ? "Set" : "Not set",
              message: error.message,
            }
          : undefined,
    });
  }
});

export default router;
