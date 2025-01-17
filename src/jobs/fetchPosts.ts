export const getPostContent = async (postUrls: string[]) => {
    const accessToken = process.env.BRIGHT_DATA_TOKEN!;
    try {
        // Add input validation and formatting
        if (!Array.isArray(postUrls)) {
            // If a single string is passed, convert it to an array
            if (typeof postUrls === 'string') {
                postUrls = [postUrls];
            } else {
                throw new Error('postUrls must be an array of strings or a single string');
            }
        }

        // Log the input for debugging
        console.log('Processing URLs:', postUrls);

        // First API call to trigger the dataset
        const triggerResponse = await fetch('https://api.brightdata.com/datasets/v3/trigger?dataset_id=gd_lyy3tktm25m4avu764&include_errors=true', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${accessToken}`,
                'Content-Type': 'application/json'
            },
            // Ensure proper formatting of the request body
            body: JSON.stringify(postUrls.map(url => ({ url: url.trim() })))
        });

        if (!triggerResponse.ok) {
            const errorText = await triggerResponse.text();
            console.error('Trigger response error:', errorText);
            throw new Error(`Failed to trigger dataset: ${errorText}`);
        }

        const triggerData = await triggerResponse.json();
        console.log('Trigger response:', triggerData);
        const snapshotId = triggerData.snapshot_id;

        // Function to fetch snapshot with retries
        const fetchSnapshot = async (retries = 5, delay = 10000): Promise<any> => {
            for (let attempt = 0; attempt < retries; attempt++) {
                const snapshotResponse = await fetch(`https://api.brightdata.com/datasets/v3/snapshot/${snapshotId}?format=json`, {
                    headers: {
                        'Authorization': `Bearer ${accessToken}`
                    }
                });

                if (!snapshotResponse.ok) {
                    const errorText = await snapshotResponse.text();
                    throw new Error(`Failed to fetch snapshot data: ${errorText}`);
                }

                const snapshotData = await snapshotResponse.json();

                // Check if snapshot is still running
                if (snapshotData.status === "running") {
                    console.log(`Snapshot still running, attempt ${attempt + 1}/${retries}. Waiting ${delay / 1000}s...`);
                    await new Promise(resolve => setTimeout(resolve, delay));
                    continue;
                }

                // If we have actual data, return it
                if (Array.isArray(snapshotData) && snapshotData.length > 0) {
                    return snapshotData;
                }

                // If we got a response but no data, throw an error
                throw new Error('No data found in snapshot response');
            }
            throw new Error('Max retries reached while waiting for snapshot');
        };

        // Fetch snapshot with retries
        const snapshotData = await fetchSnapshot();

        // Process all posts in the snapshot data
        const processedPosts = snapshotData.map(post => ({
            text: post.post_text || '',
            hashtags: post.hashtags || [],
            date: post.date_posted,
            likes: post.num_likes,
            comments: post.num_comments,
            postUrn: post.id,
            author: {
                name: post.user_id,
                title: post.user_title,
                followers: post.user_followers
            }
        }));

        return processedPosts;
    } catch (error) {
        console.error('Error fetching post content:', error);
        throw error;
    }
};
