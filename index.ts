import express from 'express';
import cors from 'cors';
import { createInstagramFetcher } from './src/jobs/fetchPosts';
import { createInstagramCommenter } from './src/services/postComments';

const app = express();
const port = process.env.PORT || 3000;
console.log(process.env.APIFY_API_TOKEN);

// Initialize Instagram fetcher
const instagramFetcher = createInstagramFetcher(process.env.APIFY_API_TOKEN!);
const instagramCommenter = createInstagramCommenter(process.env.INSTA_ACCESS_TOKEN!);

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.post('/api/hashtags', async (req, res) => {
    const { hashtags, resultsLimit, resultsType } = req.body;

    const result = await instagramFetcher.fetchPosts({
        hashtags,
        resultsLimit,
        resultsType
    });

    if (!result.success) {
        return res.status(500).json(result);
    }

    res.json(result);
});

app.post('/api/comment-on-hashtags', async (req, res) => {
    try {
        const { hashtags, resultsLimit = 3 } = req.body; // Default to 5 posts to be safe

        // 1. Fetch posts
        const postsResult = await instagramFetcher.fetchPosts({
            hashtags,
            resultsLimit,
            resultsType: 'posts'
        });

        if (!postsResult.success) {
            return res.status(500).json(postsResult);
        }

        if (!postsResult.items || postsResult.items.length === 0) {
            return res.status(200).json({
                success: true,
                postsFound: 0,
                comments: [],
                hashtags
            });
        }

        // 2. Extract media IDs and post comments
        const mediaIds = postsResult.items.map(post => post.id);
        console.log(postsResult)
        console.log(mediaIds);
        const commentResults = await instagramCommenter.commentOnMultiplePosts(mediaIds);

        // 3. Return combined results
        res.json({
            success: true,
            postsFound: postsResult.count,
            comments: commentResults,
            hashtags
        });

    } catch (error: any) {
        console.error('Error in comment-on-hashtags:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to process request',
            details: error.message
        });
    }
});

// Start server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
