import { createCommentChain } from "../chains/comment-chain";

// Create the chain once and reuse it
const commentChain = createCommentChain();

export const generateComment = async (postContent: string) => {
    const result = await commentChain.invoke({
        postContent,
    });
    return result.text;
};
