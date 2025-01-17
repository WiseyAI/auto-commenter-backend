import { getPostContent } from "../jobs/fetchPosts";
import { generateComment } from "../jobs/generateComment";
import { postComment } from "../jobs/postComment";

type ProcessResult = {
    postUrn: string;
    comment: string;
    status: 'success' | 'error';
    error?: string;
};

export const processLinkedinPost = async (postUrls: string[], accessToken: string): Promise<ProcessResult[]> => {
    try {
        // 1. Get content for all posts
        const postsContent = await getPostContent(postUrls);

        // 2. Process each post sequentially to avoid rate limits
        const results: ProcessResult[] = [];

        for (const post of postsContent) {
            try {
                // Generate comment for this post
                const comment = await generateComment(post);

                // Post the comment
                await postComment(post.postUrn, comment, accessToken);

                // Store the result
                results.push({
                    postUrn: post.postUrn,
                    comment,
                    status: 'success'
                });

            } catch (error) {
                // Handle errors for individual posts
                results.push({
                    postUrn: post.postUrn,
                    comment: '',
                    status: 'error',
                    error: error instanceof Error ? error.message : 'Unknown error'
                });
            }
        }

        return results;

    } catch (error) {
        // Handle errors for the entire process
        console.error('Error processing LinkedIn posts:', error);
        throw error;
    }
};
