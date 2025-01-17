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
