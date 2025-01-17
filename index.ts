import express from 'express';
import cors from 'cors';
import prisma from '@repo/db/client';
import commentRoutes from './src/routes/comment';

const app = express();
const port = process.env.PORT || 8080;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.get('/', async (req, res) => {
const users = await prisma.user.findMany();
return res.json(users);
});

app.use('/api', commentRoutes);

// Start server
app.listen(port, () => {
console.log(`Server running at http://localhost:${port}`);
});
