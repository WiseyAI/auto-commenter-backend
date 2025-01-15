// src/jobs/postComments.ts
interface CommentResponse {
    success: boolean;
    error?: string;
    mediaId?: string;
}

export class InstagramCommenter {
    private accessToken: string;
    private readonly defaultComment = "Aryan from olly has commented on this!";

    constructor(accessToken: string) {
        this.accessToken = accessToken;
    }

    async postComment(mediaId: string, message: string = this.defaultComment): Promise<CommentResponse> {
        try {
            const commentResponse = await fetch(
                `https://graph.instagram.com/v21.0/${mediaId}/comments`,
                {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify({
                        message: message,
                        access_token: this.accessToken,
                    }),
                }
            );

            if (!commentResponse.ok) {
                const errorData = await commentResponse.json();
                throw new Error(`Failed to post comment: ${errorData.error?.message || 'Unknown error'}`);
            }

            return {
                success: true,
                mediaId
            };
        } catch (error: any) {
            console.error(`Error posting comment on media ${mediaId}:`, error);
            return {
                success: false,
                error: error.message,
                mediaId
            };
        }
    }

    async commentOnMultiplePosts(mediaIds: string[]): Promise<CommentResponse[]> {
        // Add delay between comments to avoid rate limiting
        const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

        const results: CommentResponse[] = [];

        for (const mediaId of mediaIds) {
            const result = await this.postComment(mediaId);
            results.push(result);

            // Add a 2-second delay between comments to avoid rate limiting
            await delay(2000);
        }

        return results;
    }
}

export const createInstagramCommenter = (accessToken: string) => {
    return new InstagramCommenter(accessToken);
};
