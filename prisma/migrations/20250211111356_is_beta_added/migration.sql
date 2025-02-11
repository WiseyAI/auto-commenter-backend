/*
  Warnings:

  - Added the required column `userId` to the `AutoCommenterHistory` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "AutoCommenterHistory" ADD COLUMN     "userId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Prompt" ADD COLUMN     "creditCost" INTEGER NOT NULL DEFAULT 5,
ADD COLUMN     "isPremium" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "isBetaTester" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "SubLicenseGoal" (
    "id" TEXT NOT NULL,
    "subLicenseId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "goal" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "daysToAchieve" INTEGER,

    CONSTRAINT "SubLicenseGoal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UnlockedPrompt" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "promptId" TEXT NOT NULL,
    "unlockedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UnlockedPrompt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PostCache" (
    "id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "snapshotData" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastAccessed" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PostCache_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "UnlockedPrompt_userId_idx" ON "UnlockedPrompt"("userId");

-- CreateIndex
CREATE INDEX "UnlockedPrompt_promptId_idx" ON "UnlockedPrompt"("promptId");

-- CreateIndex
CREATE UNIQUE INDEX "UnlockedPrompt_userId_promptId_key" ON "UnlockedPrompt"("userId", "promptId");

-- CreateIndex
CREATE UNIQUE INDEX "PostCache_url_key" ON "PostCache"("url");

-- CreateIndex
CREATE INDEX "PostCache_url_idx" ON "PostCache"("url");

-- CreateIndex
CREATE INDEX "AutoCommenterHistory_userId_idx" ON "AutoCommenterHistory"("userId");

-- AddForeignKey
ALTER TABLE "SubLicenseGoal" ADD CONSTRAINT "SubLicenseGoal_subLicenseId_fkey" FOREIGN KEY ("subLicenseId") REFERENCES "SubLicense"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubLicenseGoal" ADD CONSTRAINT "SubLicenseGoal_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UnlockedPrompt" ADD CONSTRAINT "UnlockedPrompt_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UnlockedPrompt" ADD CONSTRAINT "UnlockedPrompt_promptId_fkey" FOREIGN KEY ("promptId") REFERENCES "Prompt"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutoCommenterHistory" ADD CONSTRAINT "AutoCommenterHistory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
