// src/jobs/postComment.ts
export const postComment = async (
  postUrn: string,
  commentText: string,
  accessToken: string,
) => {
  try {
    // Get the current user's URN first
    const userResponse = await fetch("https://api.linkedin.com/v2/userinfo", {
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "X-Restli-Protocol-Version": "2.0.0",
      },
    });
    if (!userResponse.ok) {
      const userError = await userResponse.text();
      throw new Error(
        `Failed to fetch user profile: ${userResponse.status} ${userError}`,
      );
    }
    const userData = await userResponse.json();
    const userUrn = `urn:li:person:${userData.sub}`;

    // Format the post URN if it's just a numeric ID
    const formattedPostUrn = postUrn.includes("urn:li")
      ? postUrn
      : `urn:li:activity:${postUrn}`;

    // Ensure the URN is properly encoded for the API request
    const encodedUrn = encodeURIComponent(formattedPostUrn);

    const response = await fetch(
      `https://api.linkedin.com/v2/socialActions/${encodedUrn}/comments`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
          "X-Restli-Protocol-Version": "2.0.0",
        },
        body: JSON.stringify({
          actor: userUrn,
          message: {
            text: commentText,
            attributes: [],
          },
          object: formattedPostUrn, // Use the formatted URN here
        }),
      },
    );

    if (!response.ok) {
      const responseText = await response.text();
      let errorMessage;
      try {
        const errorData = JSON.parse(responseText);
        errorMessage =
          errorData.message || errorData.code || "Failed to create comment";
      } catch {
        errorMessage = responseText || "Failed to create comment";
      }
      throw new Error(`LinkedIn API Error: ${errorMessage}`);
    }

    const responseText = await response.text();
    try {
      return JSON.parse(responseText);
    } catch {
      return { success: true };
    }
  } catch (error) {
    console.error("Error posting comment:", error);
    throw error;
  }
};
