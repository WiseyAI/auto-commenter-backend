//src/cron/autoCommenter.ts
import cron from "node-cron";
import { runAutoCommenter } from "../jobs/autoCommenterJob";

export function setupAutoCommenterCron() {
  // Run every hour
  cron.schedule("0 * * * *", async () => {
    console.log("Starting scheduled auto commenter job");
    try {
      await runAutoCommenter();
    } catch (error) {
      console.error("Scheduled auto commenter job failed:", error);
    }
  });
}
