import express, { type Request, type Response } from "express";
import cors from "cors";
import prisma from "./lib/db";
import commentRoutes from "./routes/comment";
import sheetRoutes from "./routes/sheet";
import autoCommeterRoutes from "./routes/autoCommenter";
import { asyncHandler } from "./middleware/asyncHandler";

const app = express();
const port = process.env.PORT || 8080;

app.use(cors());
app.use(express.json());

// Routes
app.get(
  "/",
  asyncHandler(async (req: Request, res: Response) => {
    const users = await prisma.user.findMany();
    return res.json(users);
  }),
);

app.use("/api", commentRoutes);
app.use("/api", sheetRoutes);
app.use("/api", autoCommeterRoutes);

// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
