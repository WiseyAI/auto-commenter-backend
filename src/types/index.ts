// Error handling types
export interface ApiError extends Error {
    statusCode: number;
}
