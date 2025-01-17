export const getPostContent = async (postUrn: string, accessToken: string) => {
    const response = await fetch(`https://api.linkedin.com/v2/ugcPosts/${postUrn}`, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'X-Restli-Protocol-Version': '2.0.0',
        },
    });

    if (!response.ok) {
        throw new Error('Failed to fetch post content');
    }

    const post = await response.json();
    return post.content.text || '';
};
