import express from "express";
import cors from "cors";
import prisma from "@repo/db/client";
const app = express();
const port = process.env.PORT || 8080;

// Middleware
app.use(cors());
app.use(express.json());

app.get("/", async (req, res) => {
  const users = await prisma.user.findMany();
  return res.json(users);
});

// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
