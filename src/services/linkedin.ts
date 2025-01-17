import { getPostContent } from "../jobs/fetchPosts";
import { generateComment } from "../jobs/generateComment";
import { postComment } from "../jobs/postComment";

export const processLinkedinPost = async (postUrl: string, accessToken: string) => {
    // 1. Get post content
    const postContent = await getPostContent(postUrl);

    // 2. Generate comment using LangChain
    const comment = await generateComment(postContent);

    // 3. Post the comment
    await postComment(postContent.postUrn, comment, accessToken);

    return comment;
};
