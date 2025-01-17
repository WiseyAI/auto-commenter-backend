// src/routes/comment.ts
import express, { type Request, type Response } from 'express';
import { processLinkedinPost } from '../services/linkedin';
import { postComment } from '../jobs/postComment';
import { decrypt } from '../services/encryption';
import { asyncHandler } from '../middleware/asyncHandler';
import { getPostContent } from '../jobs/fetchPosts';
import { generateComment } from '../jobs/generateComment';

const router = express.Router();

router.post('/comment', asyncHandler(async (req: Request, res: Response) => {
    try {
        const { postUrls } = req.body;  // Expect an array of URLs
        const accessToken = process.env.TEST_ACCESS_TOKEN;

        // Validate input
        if (!Array.isArray(postUrls) || postUrls.length === 0 || !accessToken) {
            return res.status(400).json({ error: 'Missing required parameters or invalid postUrls format' });
        }

        const decryptedAccessToken = decrypt(accessToken);

        // Process all URLs and collect results
        const results = [];
        const errors = [];

        for (const url of postUrls) {
            try {
                const comment = await processLinkedinPost(url, decryptedAccessToken);
                results.push({
                    url,
                    success: true,
                    comment
                });
            } catch (error) {
                errors.push({
                    url,
                    error: error instanceof Error ? error.message : 'Processing error'
                });
            }
        }

        console.log('reload page');

        res.json({
            success: true,
            processed: results,
            errors: errors.length > 0 ? errors : undefined
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            error: error instanceof Error ? error.message : 'Internal server error'
        });
    }
}));
router.post('/comment/test', asyncHandler(async (req: Request, res: Response) => {
    try {
        const { postId, message } = req.body;
        const accessToken = process.env.TEST_ACCESS_TOKEN!;
        if (!postId || !accessToken) {
            return res.status(400).json({ error: 'Missing required parameters' });
        }

        const decryptedAccessToken = decrypt(accessToken);
        console.log('accessToken', decryptedAccessToken);



        const comment = await postComment(postId, message, decryptedAccessToken);

        res.json({
            success: true,
            comment
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            error: error instanceof Error ? error.message : 'Internal server error'
        });
    }
}));

router.post('/post/test', asyncHandler(async (req: Request, res: Response) => {
    try {
        const { postUrl } = req.body;
        const accessToken = process.env.BRIGHT_DATA_TOKEN!;
        if (!postUrl || !accessToken) {
            return res.status(400).json({ error: 'Missing required parameters' });
        }

        const post = await getPostContent(postUrl);
        const comment = await generateComment(post);

        res.json({
            success: true,
            comment
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            error: error instanceof Error ? error.message : 'Internal server error'
        });
    }
}))



export default router;
