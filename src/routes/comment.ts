// src/routes/comment.ts
import express from 'express';
import { processLinkedinPost } from '../services/linkedin';
import { postComment } from '../jobs/postComment';
import { decrypt } from '../services/encryption';

const router = express.Router();

router.post('/comment', async (req, res) => {
    try {
        const { postId, accessToken } = req.body;

        if (!postId || !accessToken) {
            return res.status(400).json({ error: 'Missing required parameters' });
        }

        const comment = await processLinkedinPost(postId, accessToken);

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
});

router.post('/comment/test', async (req, res) => {
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
});

export default router;
