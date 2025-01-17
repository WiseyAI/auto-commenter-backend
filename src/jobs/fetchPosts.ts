export const getPostContent = async (postUrl: string) => {
    const accessToken = process.env.BRIGHT_DATA_TOKEN!;
    try {
        // First API call to trigger the dataset
        const triggerResponse = await fetch('https://api.brightdata.com/datasets/v3/trigger?dataset_id=gd_lyy3tktm25m4avu764&include_errors=true', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${accessToken}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify([{ url: postUrl }])
        });

        if (!triggerResponse.ok) {
            throw new Error('Failed to trigger dataset');
        }

        const triggerData = await triggerResponse.json();
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
                    throw new Error('Failed to fetch snapshot data');
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

        // Process the snapshot data
        const post = snapshotData[0];

        // Combine relevant post information
        const content = {
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
        };

        return content;

    } catch (error) {
        console.error('Error fetching post content:', error);
        throw error;
    }
};
