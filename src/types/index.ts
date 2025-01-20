// Error handling types
export interface ApiError extends Error {
  statusCode: number;
}

export interface PostAuthor {
  name: string | null;
  title: string;
  followers: number;
}

export interface Post {
  text: string;
  hashtags: string[];
  date: string;
  likes: number;
  comments: number;
  author: PostAuthor;
}

export interface PostResponse {
  success: boolean;
  post: Post;
}

export type ProcessResult = {
  postUrn: string;
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
