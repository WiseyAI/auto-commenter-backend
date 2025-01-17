import { createCommentChain } from "../chains/comment-chain";
import type { Post } from "../types";

// Create the chain once and reuse it
const commentChain = createCommentChain();

export const generateComment = async (postContent: Post) => {
    const result = await commentChain.invoke({
        postContent,
    });
    return result.text;
};
