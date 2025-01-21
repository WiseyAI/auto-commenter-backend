//src/services/creditManager.ts
import { PrismaClient, TransactionType } from "@prisma/client";
const prisma = new PrismaClient();

export async function deductCreditsForAutoComment(
  userId: string,
  amount: number,
  postId: string,
) {
  return await prisma.$transaction(async (tx) => {
    const userCredit = await tx.userCredit.findUnique({
      where: { userId },
    });

    if (!userCredit || userCredit.balance < amount) {
      throw new Error("Insufficient credits");
    }

    const transaction = await tx.creditTransaction.create({
      data: {
        userCreditId: userCredit.id,
        amount: -amount,
        type: TransactionType.AUTO_COMMENTING,
        description: `Auto comment on post ${postId}`,
      },
    });

    const updatedCredit = await tx.userCredit.update({
      where: { id: userCredit.id },
      data: {
        balance: { decrement: amount },
      },
    });

    return { transaction, updatedCredit };
  });
}
