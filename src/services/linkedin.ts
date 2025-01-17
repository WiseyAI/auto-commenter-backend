import { getPostContent } from "../jobs/fetchPosts";
import { generateComment } from "../jobs/generateComment";
import { postComment } from "../jobs/postComment";

export const processLinkedinPost = async (postUrn: string, accessToken: string) => {
    // 1. Get post content
    const postContent = await getPostContent(postUrn, accessToken);

    // 2. Generate comment using LangChain
    const comment = await generateComment(postContent);

    // 3. Post the comment
    await postComment(postUrn, comment, accessToken);

    return comment;
};
