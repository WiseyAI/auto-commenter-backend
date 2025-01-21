// Error handling types
export interface ApiError extends Error {
  statusCode: number;
}

export interface Author {
  name: string;
  title: string;
  followers: number;
}

export interface ProcessedPost {
  text: string;
  hashtags: string[];
  date: string | Date; // depending on the format of date_posted
  likes: number;
  comments: number;
  postUrn: string;
  postUrl: string;
  author: Author;
}

export interface SnapshotData {
  post_text?: string;
  hashtags?: string[];
  date_posted: string | Date;
  num_likes: number;
  num_comments: number;
  id: string;
  url: string;
  headline: string;
  user_title: string;
  user_followers?: number;
}

export interface PostResponse {
  success: boolean;
  post: ProcessedPost;
}

export type ProcessResult = {
  postUrn: string;
  postUrl: string;
  postContent: string;
  authorName: string;
  comment: string;
  status: "success" | "error";
  error?: string;
};

export interface ColumnData {
  [columnName: string]: string[];
}

export interface SheetResponse {
  success: boolean;
  data?: ColumnData | string[];
  error?: string;
  totalColumns?: number;
  rowsPerColumn?: number;
  column?: string;
}

export interface ColumnResponse {
  success: boolean;
  data?: string[];
  error?: string;
}
