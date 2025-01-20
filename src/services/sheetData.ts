import { parse } from "csv-parse";
import type { ColumnData, SheetResponse } from "../types";

export const fetchSheetData = async (sheetId: string): Promise<string> => {
  if (!sheetId) {
    throw new Error("Sheet ID is not defined");
  }

  const url = `https://docs.google.com/spreadsheets/d/${sheetId}/gviz/tq?tqx=out:csv`;
  const response = await fetch(url);

  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }

  const csvData = await response.text();

  if (!csvData || csvData.trim().length === 0) {
    throw new Error("Received empty CSV data");
  }

  return csvData;
};

/**
 * Processes CSV data into column-based format
 * @param csvData - Raw CSV data string
 * @returns Promise with processed column data
 */
export const processSheetData = async (
  csvData: string,
): Promise<ColumnData> => {
  const records: Record<string, string>[] = [];
  const columnData: ColumnData = {};

  const parser = parse(csvData, {
    columns: true,
    skip_empty_lines: true,
    trim: true,
  });

  for await (const record of parser) {
    records.push(record);
  }

  if (records.length > 0) {
    const columns = Object.keys(records[0]);
    columns.forEach((column) => {
      columnData[column] = records.map((record) => record[column]);
    });
  }

  return columnData;
};

/**
 * Gets data for a specific column
 * @param columnData - Processed column data
 * @param columnName - Name of the column to retrieve
 * @returns Array of values for the specified column or null if not found
 */
export const getColumnData = (
  columnData: ColumnData,
  columnName: string,
): string[] | null => {
  const normalizedColumnName = columnName.toLowerCase();
  const columnKey = Object.keys(columnData).find(
    (key) => key.toLowerCase() === normalizedColumnName,
  );

  return columnKey ? columnData[columnKey] : null;
};

/**
 * Gets all sheet data
 * @param sheetId - Google Sheet ID
 * @returns Promise with all column data and metadata
 */
export const getAllSheetData = async (
  sheetId: string,
): Promise<SheetResponse> => {
  try {
    const csvData = await fetchSheetData(sheetId);
    const columnData = await processSheetData(csvData);

    return {
      success: true,
      data: columnData,
      totalColumns: Object.keys(columnData).length,
      rowsPerColumn: columnData[Object.keys(columnData)[0]]?.length || 0,
    };
  } catch (error) {
    return {
      success: false,
      error:
        error instanceof Error ? error.message : "Failed to fetch sheet data",
    };
  }
};

/**
 * Gets data for a specific column
 * @param sheetId - Google Sheet ID
 * @param columnName - Name of the column to retrieve
 * @returns Promise with column data and metadata
 */
export const getSpecificColumnData = async (
  sheetId: string,
  columnName: string,
): Promise<SheetResponse> => {
  try {
    const csvData = await fetchSheetData(sheetId);
    const columnData = await processSheetData(csvData);
    const specificColumnData = getColumnData(columnData, columnName);

    if (!specificColumnData) {
      return {
        success: false,
        error: `Column '${columnName}' not found`,
        data: Object.keys(columnData), // returning available columns
      };
    }

    return {
      success: true,
      data: specificColumnData,
      column: columnName,
    };
  } catch (error) {
    return {
      success: false,
      error:
        error instanceof Error ? error.message : "Failed to fetch sheet data",
    };
  }
};
