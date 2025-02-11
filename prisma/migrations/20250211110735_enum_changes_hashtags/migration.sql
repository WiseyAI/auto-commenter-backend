-- CreateEnum
CREATE TYPE "DeviceType" AS ENUM ('WEB', 'MOBILE_IOS', 'MOBILE_ANDROID', 'DESKTOP', 'OTHER');

-- CreateEnum
CREATE TYPE "InstallationStatus" AS ENUM ('INSTALLED', 'UNINSTALLED');

-- CreateEnum
CREATE TYPE "ActivationTokenType" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "OrganizationRole" AS ENUM ('OWNER', 'ADMIN', 'MEMBER');

-- CreateEnum
CREATE TYPE "SignInMethod" AS ENUM ('EMAIL', 'GOOGLE', 'OTHER');

-- CreateEnum
CREATE TYPE "PlanName" AS ENUM ('T0', 'T1', 'T2', 'T3', 'T4', 'T5');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('EARNED', 'SPENT', 'REFUNDED', 'GIFTED', 'PURCHASED', 'PLAN_CREDITS', 'PLAN_CREDITS_REMOVED', 'PLAN_CREDITS_ADJUSTED', 'AUTO_COMMENTING');

-- CreateEnum
CREATE TYPE "RedeemCodeStatus" AS ENUM ('ACTIVE', 'CLAIMED', 'EXPIRED', 'DISABLED');

-- CreateEnum
CREATE TYPE "ReviewStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "JobStatus" AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('SYSTEM', 'CREDIT_UPDATE', 'LICENSE_EXPIRY', 'TEAM_INVITE', 'USAGE_LIMIT', 'FEATURE_ANNOUNCEMENT', 'SECURITY');

-- CreateEnum
CREATE TYPE "NotificationStatus" AS ENUM ('READ', 'UNREAD', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "PlanTier" AS ENUM ('T1', 'T2', 'T3', 'T4', 'ENTERPRISE');

-- CreateEnum
CREATE TYPE "PlanDuration" AS ENUM ('MONTHLY', 'LIFETIME');

-- CreateEnum
CREATE TYPE "PlanVendor" AS ENUM ('LEMON', 'APPSUMO', 'OLLY');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('ACTIVE', 'CANCELLED', 'EXPIRED', 'PAUSED', 'PAYMENT_FAILED', 'PAST_DUE');

-- CreateEnum
CREATE TYPE "CommentPlatform" AS ENUM ('LINKEDIN', 'TWITTER', 'INSTAGRAM');

-- CreateEnum
CREATE TYPE "CommentStatus" AS ENUM ('PENDING', 'POSTED', 'FAILED', 'SKIPPED');

-- CreateEnum
CREATE TYPE "Hashtag" AS ENUM ('SALES', 'TECHNOLOGY', 'GENAI', 'MARKETING', 'STARTUP', 'CONTENTCREATION', 'SOFTWAREENGINEERING', 'ECOMMERCE');

-- CreateTable
CREATE TABLE "Organization" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "isPremium" BOOLEAN NOT NULL DEFAULT false,
    "planId" TEXT,
    "mainLicenseKeyId" TEXT,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationPlan" (
    "id" TEXT NOT NULL,
    "name" "PlanName" NOT NULL,
    "maxAdditionalKeys" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "OrganizationPlan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationUser" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "role" "OrganizationRole" NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OrganizationUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LicenseKey" (
    "id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "activatedAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "activationCount" INTEGER NOT NULL DEFAULT 0,
    "vendor" TEXT,
    "planId" TEXT,
    "tier" INTEGER,
    "lemonProductId" INTEGER,
    "deActivatedAt" TIMESTAMP(3),
    "redemptionUrl" TEXT,
    "planChangeUrl" TEXT,
    "appsumoAccessToken" TEXT,
    "converted_to_team" BOOLEAN,
    "organizationId" TEXT,
    "isMainKey" BOOLEAN NOT NULL DEFAULT true,
    "additionalOrganizationId" TEXT,
    "apiKeyId" TEXT,

    CONSTRAINT "LicenseKey_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LicenseKeyCustomKnowledge" (
    "id" TEXT NOT NULL,
    "licenseKeyId" TEXT NOT NULL,
    "brandName" TEXT,
    "brandPersonality" TEXT,
    "industry" TEXT,
    "targetAudience" TEXT,
    "productServices" TEXT,
    "uniqueSellingPoints" TEXT,
    "brandVoice" TEXT,
    "contentTopics" TEXT,
    "brandValues" TEXT,
    "missionStatement" TEXT,
    "personalBackground" TEXT,
    "values" TEXT,
    "lifestyle" TEXT,
    "professionalBackground" TEXT,
    "expertise" TEXT,
    "industryInsights" TEXT,
    "uniqueApproach" TEXT,
    "contentStrategy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LicenseKeyCustomKnowledge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LicenseKeyKnowledgeSummary" (
    "id" TEXT NOT NULL,
    "licenseKeyCustomKnowledgeId" TEXT NOT NULL,
    "summary" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LicenseKeyKnowledgeSummary_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SubLicense" (
    "id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "activationCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "originalLicenseKey" TEXT,
    "deactivatedAt" TIMESTAMP(3),
    "converted_to_team" BOOLEAN,
    "vendor" TEXT,
    "mainLicenseKeyId" TEXT NOT NULL,
    "assignedUserId" TEXT,
    "assignedEmail" TEXT,

    CONSTRAINT "SubLicense_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ElfGameAttempt" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "ipAddress" TEXT,
    "sessionId" TEXT NOT NULL,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "catches" INTEGER NOT NULL DEFAULT 0,
    "lastAttemptAt" TIMESTAMP(3),
    "discountClaimed" BOOLEAN NOT NULL DEFAULT false,
    "claimedDiscount" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ElfGameAttempt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationInvite" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "role" "OrganizationRole" NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OrganizationInvite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OwnedLicense" (
    "id" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "licenseKeyId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "OwnedLicense_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssignedLicense" (
    "id" TEXT NOT NULL,
    "organizationUserId" TEXT NOT NULL,
    "ownedLicenseId" TEXT NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AssignedLicense_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LicenseKeySettings" (
    "id" TEXT NOT NULL,
    "licenseKeyId" TEXT NOT NULL,
    "userName" TEXT,
    "customButtons" JSONB,
    "customActions" JSONB,
    "model" TEXT,
    "replyTone" TEXT,
    "replyLength" TEXT,
    "toneIntent" TEXT,
    "language" TEXT,
    "usePostNativeLanguage" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LicenseKeySettings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Activation" (
    "id" TEXT NOT NULL,
    "licenseKeyId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "activatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "activationToken" TEXT NOT NULL,
    "currentlyActivated" BOOLEAN,
    "activationTokenType" "ActivationTokenType" NOT NULL,
    "deviceType" TEXT,
    "deviceModel" TEXT,
    "osName" TEXT,
    "osVersion" TEXT,
    "browser" TEXT,
    "browserVersion" TEXT,
    "ipAddress" TEXT,

    CONSTRAINT "Activation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ApiKey" (
    "id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "vendor" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ApiKey_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ApiKeyCustomKnowledge" (
    "id" TEXT NOT NULL,
    "apiKeyId" TEXT NOT NULL,
    "brandName" TEXT,
    "brandPersonality" TEXT,
    "industry" TEXT,
    "targetAudience" TEXT,
    "productServices" TEXT,
    "uniqueSellingPoints" TEXT,
    "brandVoice" TEXT,
    "contentTopics" TEXT,
    "brandValues" TEXT,
    "missionStatement" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ApiKeyCustomKnowledge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "KnowledgeSummary" (
    "id" TEXT NOT NULL,
    "apiKeyCustomKnowledgeId" TEXT NOT NULL,
    "summary" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "KnowledgeSummary_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ApiKeyUsageTracking" (
    "id" TEXT NOT NULL,
    "apiKeyId" TEXT NOT NULL,
    "usage" INTEGER NOT NULL DEFAULT 0,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endpoint" TEXT NOT NULL,
    "responseTime" INTEGER,
    "statusCode" INTEGER,
    "errorMessage" TEXT,
    "prompt" TEXT,
    "action" TEXT,
    "content" TEXT,
    "platform" TEXT,

    CONSTRAINT "ApiKeyUsageTracking_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FreeUser" (
    "id" TEXT NOT NULL,
    "externalUserId" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FreeUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmailVerificationToken" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EmailVerificationToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "externalUserId" TEXT,
    "firstLogin" BOOLEAN DEFAULT true,
    "email" TEXT,
    "name" TEXT,
    "username" TEXT,
    "password" TEXT,
    "picture" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deactivated" BOOLEAN NOT NULL DEFAULT false,
    "isAdmin" BOOLEAN NOT NULL DEFAULT false,
    "isSales" BOOLEAN NOT NULL DEFAULT false,
    "isPaidUser" BOOLEAN NOT NULL DEFAULT false,
    "onboardingComplete" BOOLEAN NOT NULL DEFAULT false,
    "thumbnailCredits" INTEGER DEFAULT 1,
    "isSupport" BOOLEAN NOT NULL DEFAULT false,
    "hasClaimedOnboardingCredits" BOOLEAN NOT NULL DEFAULT false,
    "isEmailVerified" BOOLEAN NOT NULL DEFAULT false,
    "diwali24SaleEmailSent" BOOLEAN DEFAULT false,
    "signInMethod" "SignInMethod" NOT NULL DEFAULT 'EMAIL',
    "signupSource" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Emails" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "sentAt" TIMESTAMP(3),
    "vendor" TEXT,
    "isAppsumoCourseEmailSent" BOOLEAN,

    CONSTRAINT "Emails_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Onboarding" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "industry" TEXT,
    "role" TEXT,
    "roleOther" TEXT,
    "primaryPlatform" TEXT,
    "primaryPlatformOther" TEXT,
    "businessType" TEXT,
    "engagementGoal" TEXT,
    "contentFrequency" TEXT,
    "commentFrequency" TEXT,
    "companySize" TEXT,
    "aiExperience" TEXT,
    "painPoints" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "customPainPoint" TEXT,
    "biggestChallenge" TEXT,
    "completedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "skipped" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Onboarding_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OnboardingProgress" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "currentStep" INTEGER NOT NULL DEFAULT 0,
    "isCompleted" BOOLEAN NOT NULL DEFAULT false,
    "lastUpdated" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OnboardingProgress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OnboardingFeedback" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "rating" INTEGER NOT NULL,
    "feedback" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "OnboardingFeedback_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TemporaryToken" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "licenseKeyId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TemporaryToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "token" TEXT,
    "deviceType" "DeviceType" NOT NULL DEFAULT 'WEB',
    "deviceInfo" JSONB,
    "lastActive" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "isRevoked" BOOLEAN NOT NULL DEFAULT false,
    "platformTokens" JSONB,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OAuthToken" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "accessToken" TEXT NOT NULL,
    "refreshToken" TEXT,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "isValid" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "OAuthToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RefreshToken" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "deviceType" "DeviceType" NOT NULL,
    "deviceInfo" JSONB,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "isRevoked" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RefreshToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PasswordResetToken" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PasswordResetToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserLicenseKey" (
    "userId" TEXT NOT NULL,
    "licenseKeyId" TEXT NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserLicenseKey_pkey" PRIMARY KEY ("userId","licenseKeyId")
);

-- CreateTable
CREATE TABLE "LicenseKeyLog" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "licenseKey" TEXT NOT NULL,
    "count" INTEGER NOT NULL DEFAULT 1,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LicenseKeyLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserApiKey" (
    "userId" TEXT NOT NULL,
    "apiKeyId" TEXT NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserApiKey_pkey" PRIMARY KEY ("userId","apiKeyId")
);

-- CreateTable
CREATE TABLE "FreeComment" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "prompt" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "licenseKeyId" TEXT,
    "apiKeyId" TEXT,

    CONSTRAINT "FreeComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ApiUsage" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "prompt" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "licenseKeyId" TEXT,
    "apiKeyId" TEXT,

    CONSTRAINT "ApiUsage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Leaderboard" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "freeUserId" TEXT,
    "level" INTEGER NOT NULL DEFAULT 1,
    "totalComments" INTEGER NOT NULL DEFAULT 0,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Leaderboard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UsageTracking" (
    "id" TEXT NOT NULL,
    "licenseKeyId" TEXT,
    "subLicenseId" TEXT,
    "userId" TEXT,
    "externalUserId" TEXT,
    "action" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "event" TEXT,

    CONSTRAINT "UsageTracking_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Installation" (
    "id" TEXT NOT NULL,
    "status" "InstallationStatus" NOT NULL,
    "reason" TEXT,
    "otherReason" TEXT,
    "installedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "uninstalledAt" TIMESTAMP(3),
    "licenseKeyId" TEXT,
    "apiKeyId" TEXT,
    "userId" TEXT,
    "freeUserId" TEXT,

    CONSTRAINT "Installation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Purchase" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "packId" TEXT NOT NULL,
    "credits" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "creditTransactionId" TEXT,

    CONSTRAINT "Purchase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pack" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "credits" INTEGER NOT NULL,
    "price" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Pack_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Prompt" (
    "id" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "upvotes" INTEGER NOT NULL DEFAULT 0,
    "category" TEXT NOT NULL,
    "contributor" TEXT,
    "title" TEXT,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Prompt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserUpvote" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "promptId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserUpvote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserCredit" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "balance" INTEGER NOT NULL DEFAULT 10,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserCredit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CreditTransaction" (
    "id" TEXT NOT NULL,
    "userCreditId" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "type" "TransactionType" NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CreditTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RedeemCodeBatch" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "campaign" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "validity" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdBy" TEXT,

    CONSTRAINT "RedeemCodeBatch_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RedeemCode" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "batchId" TEXT,
    "status" "RedeemCodeStatus" NOT NULL DEFAULT 'ACTIVE',
    "claimedAt" TIMESTAMP(3),
    "claimedBy" TEXT,
    "licenseKeyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RedeemCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MobileChatRequest" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "response" TEXT NOT NULL,
    "platform" TEXT,
    "deviceInfo" TEXT,
    "authToken" TEXT NOT NULL,
    "action" TEXT NOT NULL DEFAULT 'comment',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MobileChatRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BlogVisitorEmail" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "routePath" TEXT NOT NULL,
    "source" TEXT NOT NULL DEFAULT 'popup',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BlogVisitorEmail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductReview" (
    "id" TEXT NOT NULL,
    "productSlug" TEXT NOT NULL,
    "rating" INTEGER NOT NULL,
    "reviewBody" TEXT NOT NULL,
    "authorName" TEXT NOT NULL,
    "authorId" TEXT,
    "status" "ReviewStatus" NOT NULL DEFAULT 'PENDING',
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductReview_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReviewGenerationRecord" (
    "id" TEXT NOT NULL,
    "totalReviews" INTEGER NOT NULL,
    "successCount" INTEGER NOT NULL,
    "failureCount" INTEGER NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3) NOT NULL,
    "errors" TEXT[],
    "productsSummary" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ReviewGenerationRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SherlockJob" (
    "id" TEXT NOT NULL,
    "taskId" TEXT NOT NULL,
    "requestId" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "status" "JobStatus" NOT NULL,
    "outputFile" TEXT,
    "errorMessage" TEXT,
    "results" JSONB,
    "userId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "totalFound" INTEGER,
    "validFound" INTEGER,

    CONSTRAINT "SherlockJob_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserUsage" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "ipAddress" TEXT,
    "date" TIMESTAMP(3) NOT NULL,
    "count" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "UserUsage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "status" "NotificationStatus" NOT NULL DEFAULT 'UNREAD',
    "link" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "readAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Plan" (
    "id" TEXT NOT NULL,
    "tier" "PlanTier" NOT NULL,
    "duration" "PlanDuration" NOT NULL,
    "vendor" "PlanVendor" NOT NULL,
    "productId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "maxUsers" INTEGER NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Plan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserSubscription" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "planId" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endDate" TIMESTAMP(3),
    "status" "SubscriptionStatus" NOT NULL DEFAULT 'ACTIVE',
    "vendorSubId" TEXT,
    "orderId" TEXT,
    "customerId" TEXT,
    "lastBillingDate" TIMESTAMP(3),
    "nextBillingDate" TIMESTAMP(3),
    "paymentFailedDate" TIMESTAMP(3),
    "pausedAt" TIMESTAMP(3),
    "resumedAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "licenseKeyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserSubscription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutoCommenterConfig" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "licenseKeyId" TEXT,
    "isEnabled" BOOLEAN NOT NULL DEFAULT false,
    "postsPerDay" INTEGER NOT NULL DEFAULT 5,
    "hashtags" "Hashtag"[],
    "useBrandVoice" BOOLEAN NOT NULL DEFAULT true,
    "platform" "CommentPlatform" NOT NULL DEFAULT 'LINKEDIN',
    "accessToken" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AutoCommenterConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutoCommenterHistory" (
    "id" TEXT NOT NULL,
    "configId" TEXT NOT NULL,
    "postId" TEXT NOT NULL,
    "platform" "CommentPlatform" NOT NULL DEFAULT 'LINKEDIN',
    "postUrl" TEXT NOT NULL,
    "postContent" TEXT,
    "authorName" TEXT,
    "commentContent" TEXT NOT NULL,
    "status" "CommentStatus" NOT NULL DEFAULT 'PENDING',
    "postedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "errorMessage" TEXT,

    CONSTRAINT "AutoCommenterHistory_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Organization_name_key" ON "Organization"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Organization_mainLicenseKeyId_key" ON "Organization"("mainLicenseKeyId");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationPlan_name_key" ON "OrganizationPlan"("name");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationUser_userId_organizationId_key" ON "OrganizationUser"("userId", "organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "LicenseKey_key_key" ON "LicenseKey"("key");

-- CreateIndex
CREATE UNIQUE INDEX "LicenseKeyCustomKnowledge_licenseKeyId_key" ON "LicenseKeyCustomKnowledge"("licenseKeyId");

-- CreateIndex
CREATE INDEX "LicenseKeyKnowledgeSummary_licenseKeyCustomKnowledgeId_idx" ON "LicenseKeyKnowledgeSummary"("licenseKeyCustomKnowledgeId");

-- CreateIndex
CREATE UNIQUE INDEX "SubLicense_key_key" ON "SubLicense"("key");

-- CreateIndex
CREATE INDEX "ElfGameAttempt_lastAttemptAt_idx" ON "ElfGameAttempt"("lastAttemptAt");

-- CreateIndex
CREATE UNIQUE INDEX "ElfGameAttempt_userId_sessionId_key" ON "ElfGameAttempt"("userId", "sessionId");

-- CreateIndex
CREATE UNIQUE INDEX "ElfGameAttempt_ipAddress_sessionId_key" ON "ElfGameAttempt"("ipAddress", "sessionId");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationInvite_token_key" ON "OrganizationInvite"("token");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationInvite_email_organizationId_key" ON "OrganizationInvite"("email", "organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "OwnedLicense_organizationId_licenseKeyId_key" ON "OwnedLicense"("organizationId", "licenseKeyId");

-- CreateIndex
CREATE UNIQUE INDEX "AssignedLicense_organizationUserId_ownedLicenseId_key" ON "AssignedLicense"("organizationUserId", "ownedLicenseId");

-- CreateIndex
CREATE UNIQUE INDEX "LicenseKeySettings_licenseKeyId_key" ON "LicenseKeySettings"("licenseKeyId");

-- CreateIndex
CREATE UNIQUE INDEX "Activation_activationToken_key" ON "Activation"("activationToken");

-- CreateIndex
CREATE INDEX "Activation_licenseKeyId_idx" ON "Activation"("licenseKeyId");

-- CreateIndex
CREATE INDEX "Activation_userId_idx" ON "Activation"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "ApiKey_key_key" ON "ApiKey"("key");

-- CreateIndex
CREATE UNIQUE INDEX "ApiKeyCustomKnowledge_apiKeyId_key" ON "ApiKeyCustomKnowledge"("apiKeyId");

-- CreateIndex
CREATE INDEX "KnowledgeSummary_apiKeyCustomKnowledgeId_idx" ON "KnowledgeSummary"("apiKeyCustomKnowledgeId");

-- CreateIndex
CREATE INDEX "ApiKeyUsageTracking_apiKeyId_idx" ON "ApiKeyUsageTracking"("apiKeyId");

-- CreateIndex
CREATE INDEX "ApiKeyUsageTracking_date_idx" ON "ApiKeyUsageTracking"("date");

-- CreateIndex
CREATE UNIQUE INDEX "ApiKeyUsageTracking_apiKeyId_date_endpoint_key" ON "ApiKeyUsageTracking"("apiKeyId", "date", "endpoint");

-- CreateIndex
CREATE UNIQUE INDEX "FreeUser_externalUserId_key" ON "FreeUser"("externalUserId");

-- CreateIndex
CREATE UNIQUE INDEX "FreeUser_username_key" ON "FreeUser"("username");

-- CreateIndex
CREATE UNIQUE INDEX "EmailVerificationToken_token_key" ON "EmailVerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "User_externalUserId_key" ON "User"("externalUserId");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Emails_userId_key" ON "Emails"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Onboarding_userId_key" ON "Onboarding"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "OnboardingProgress_userId_key" ON "OnboardingProgress"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "OnboardingFeedback_userId_key" ON "OnboardingFeedback"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "TemporaryToken_token_key" ON "TemporaryToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "Session_token_key" ON "Session"("token");

-- CreateIndex
CREATE INDEX "Session_token_idx" ON "Session"("token");

-- CreateIndex
CREATE INDEX "Session_userId_idx" ON "Session"("userId");

-- CreateIndex
CREATE INDEX "OAuthToken_userId_idx" ON "OAuthToken"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "OAuthToken_userId_platform_key" ON "OAuthToken"("userId", "platform");

-- CreateIndex
CREATE UNIQUE INDEX "RefreshToken_token_key" ON "RefreshToken"("token");

-- CreateIndex
CREATE INDEX "RefreshToken_userId_idx" ON "RefreshToken"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "PasswordResetToken_token_key" ON "PasswordResetToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "LicenseKeyLog_date_userId_licenseKey_key" ON "LicenseKeyLog"("date", "userId", "licenseKey");

-- CreateIndex
CREATE UNIQUE INDEX "Leaderboard_userId_key" ON "Leaderboard"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Leaderboard_freeUserId_key" ON "Leaderboard"("freeUserId");

-- CreateIndex
CREATE INDEX "Leaderboard_userId_idx" ON "Leaderboard"("userId");

-- CreateIndex
CREATE INDEX "Leaderboard_freeUserId_idx" ON "Leaderboard"("freeUserId");

-- CreateIndex
CREATE INDEX "UsageTracking_licenseKeyId_idx" ON "UsageTracking"("licenseKeyId");

-- CreateIndex
CREATE INDEX "UsageTracking_subLicenseId_idx" ON "UsageTracking"("subLicenseId");

-- CreateIndex
CREATE INDEX "UsageTracking_userId_idx" ON "UsageTracking"("userId");

-- CreateIndex
CREATE INDEX "UsageTracking_externalUserId_idx" ON "UsageTracking"("externalUserId");

-- CreateIndex
CREATE UNIQUE INDEX "Purchase_creditTransactionId_key" ON "Purchase"("creditTransactionId");

-- CreateIndex
CREATE INDEX "Prompt_userId_idx" ON "Prompt"("userId");

-- CreateIndex
CREATE INDEX "UserUpvote_userId_idx" ON "UserUpvote"("userId");

-- CreateIndex
CREATE INDEX "UserUpvote_promptId_idx" ON "UserUpvote"("promptId");

-- CreateIndex
CREATE UNIQUE INDEX "UserUpvote_userId_promptId_key" ON "UserUpvote"("userId", "promptId");

-- CreateIndex
CREATE UNIQUE INDEX "UserCredit_userId_key" ON "UserCredit"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "RedeemCode_code_key" ON "RedeemCode"("code");

-- CreateIndex
CREATE INDEX "RedeemCode_code_idx" ON "RedeemCode"("code");

-- CreateIndex
CREATE INDEX "RedeemCode_batchId_idx" ON "RedeemCode"("batchId");

-- CreateIndex
CREATE INDEX "RedeemCode_status_idx" ON "RedeemCode"("status");

-- CreateIndex
CREATE INDEX "MobileChatRequest_authToken_idx" ON "MobileChatRequest"("authToken");

-- CreateIndex
CREATE INDEX "MobileChatRequest_createdAt_idx" ON "MobileChatRequest"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "BlogVisitorEmail_email_key" ON "BlogVisitorEmail"("email");

-- CreateIndex
CREATE INDEX "ProductReview_productSlug_idx" ON "ProductReview"("productSlug");

-- CreateIndex
CREATE INDEX "ProductReview_authorId_idx" ON "ProductReview"("authorId");

-- CreateIndex
CREATE INDEX "ReviewGenerationRecord_createdAt_idx" ON "ReviewGenerationRecord"("createdAt");

-- CreateIndex
CREATE INDEX "SherlockJob_status_idx" ON "SherlockJob"("status");

-- CreateIndex
CREATE INDEX "SherlockJob_userId_idx" ON "SherlockJob"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "SherlockJob_taskId_key" ON "SherlockJob"("taskId");

-- CreateIndex
CREATE UNIQUE INDEX "SherlockJob_requestId_key" ON "SherlockJob"("requestId");

-- CreateIndex
CREATE UNIQUE INDEX "UserUsage_userId_date_key" ON "UserUsage"("userId", "date");

-- CreateIndex
CREATE UNIQUE INDEX "UserUsage_ipAddress_date_key" ON "UserUsage"("ipAddress", "date");

-- CreateIndex
CREATE INDEX "Notification_userId_idx" ON "Notification"("userId");

-- CreateIndex
CREATE INDEX "Notification_status_idx" ON "Notification"("status");

-- CreateIndex
CREATE INDEX "Notification_createdAt_idx" ON "Notification"("createdAt");

-- CreateIndex
CREATE INDEX "Plan_tier_duration_vendor_idx" ON "Plan"("tier", "duration", "vendor");

-- CreateIndex
CREATE UNIQUE INDEX "Plan_vendor_productId_key" ON "Plan"("vendor", "productId");

-- CreateIndex
CREATE UNIQUE INDEX "UserSubscription_vendorSubId_key" ON "UserSubscription"("vendorSubId");

-- CreateIndex
CREATE INDEX "UserSubscription_userId_idx" ON "UserSubscription"("userId");

-- CreateIndex
CREATE INDEX "UserSubscription_status_idx" ON "UserSubscription"("status");

-- CreateIndex
CREATE INDEX "UserSubscription_licenseKeyId_idx" ON "UserSubscription"("licenseKeyId");

-- CreateIndex
CREATE UNIQUE INDEX "AutoCommenterConfig_userId_key" ON "AutoCommenterConfig"("userId");

-- CreateIndex
CREATE INDEX "AutoCommenterConfig_userId_idx" ON "AutoCommenterConfig"("userId");

-- CreateIndex
CREATE INDEX "AutoCommenterConfig_licenseKeyId_idx" ON "AutoCommenterConfig"("licenseKeyId");

-- CreateIndex
CREATE INDEX "AutoCommenterHistory_configId_idx" ON "AutoCommenterHistory"("configId");

-- CreateIndex
CREATE INDEX "AutoCommenterHistory_postId_idx" ON "AutoCommenterHistory"("postId");

-- CreateIndex
CREATE INDEX "AutoCommenterHistory_status_idx" ON "AutoCommenterHistory"("status");

-- CreateIndex
CREATE INDEX "AutoCommenterHistory_platform_idx" ON "AutoCommenterHistory"("platform");

-- AddForeignKey
ALTER TABLE "Organization" ADD CONSTRAINT "Organization_planId_fkey" FOREIGN KEY ("planId") REFERENCES "OrganizationPlan"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Organization" ADD CONSTRAINT "Organization_mainLicenseKeyId_fkey" FOREIGN KEY ("mainLicenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationUser" ADD CONSTRAINT "OrganizationUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationUser" ADD CONSTRAINT "OrganizationUser_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LicenseKey" ADD CONSTRAINT "LicenseKey_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LicenseKey" ADD CONSTRAINT "LicenseKey_additionalOrganizationId_fkey" FOREIGN KEY ("additionalOrganizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LicenseKey" ADD CONSTRAINT "LicenseKey_apiKeyId_fkey" FOREIGN KEY ("apiKeyId") REFERENCES "ApiKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LicenseKeyCustomKnowledge" ADD CONSTRAINT "LicenseKeyCustomKnowledge_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LicenseKeyKnowledgeSummary" ADD CONSTRAINT "LicenseKeyKnowledgeSummary_licenseKeyCustomKnowledgeId_fkey" FOREIGN KEY ("licenseKeyCustomKnowledgeId") REFERENCES "LicenseKeyCustomKnowledge"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubLicense" ADD CONSTRAINT "SubLicense_mainLicenseKeyId_fkey" FOREIGN KEY ("mainLicenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubLicense" ADD CONSTRAINT "SubLicense_assignedUserId_fkey" FOREIGN KEY ("assignedUserId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ElfGameAttempt" ADD CONSTRAINT "ElfGameAttempt_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationInvite" ADD CONSTRAINT "OrganizationInvite_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OwnedLicense" ADD CONSTRAINT "OwnedLicense_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OwnedLicense" ADD CONSTRAINT "OwnedLicense_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssignedLicense" ADD CONSTRAINT "AssignedLicense_organizationUserId_fkey" FOREIGN KEY ("organizationUserId") REFERENCES "OrganizationUser"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssignedLicense" ADD CONSTRAINT "AssignedLicense_ownedLicenseId_fkey" FOREIGN KEY ("ownedLicenseId") REFERENCES "OwnedLicense"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LicenseKeySettings" ADD CONSTRAINT "LicenseKeySettings_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Activation" ADD CONSTRAINT "Activation_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Activation" ADD CONSTRAINT "Activation_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ApiKeyCustomKnowledge" ADD CONSTRAINT "ApiKeyCustomKnowledge_apiKeyId_fkey" FOREIGN KEY ("apiKeyId") REFERENCES "ApiKey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "KnowledgeSummary" ADD CONSTRAINT "KnowledgeSummary_apiKeyCustomKnowledgeId_fkey" FOREIGN KEY ("apiKeyCustomKnowledgeId") REFERENCES "ApiKeyCustomKnowledge"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ApiKeyUsageTracking" ADD CONSTRAINT "ApiKeyUsageTracking_apiKeyId_fkey" FOREIGN KEY ("apiKeyId") REFERENCES "ApiKey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmailVerificationToken" ADD CONSTRAINT "EmailVerificationToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Emails" ADD CONSTRAINT "Emails_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Onboarding" ADD CONSTRAINT "Onboarding_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OnboardingProgress" ADD CONSTRAINT "OnboardingProgress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OnboardingFeedback" ADD CONSTRAINT "OnboardingFeedback_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TemporaryToken" ADD CONSTRAINT "TemporaryToken_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OAuthToken" ADD CONSTRAINT "OAuthToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RefreshToken" ADD CONSTRAINT "RefreshToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PasswordResetToken" ADD CONSTRAINT "PasswordResetToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserLicenseKey" ADD CONSTRAINT "UserLicenseKey_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserLicenseKey" ADD CONSTRAINT "UserLicenseKey_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserApiKey" ADD CONSTRAINT "UserApiKey_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserApiKey" ADD CONSTRAINT "UserApiKey_apiKeyId_fkey" FOREIGN KEY ("apiKeyId") REFERENCES "ApiKey"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FreeComment" ADD CONSTRAINT "FreeComment_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FreeComment" ADD CONSTRAINT "FreeComment_apiKeyId_fkey" FOREIGN KEY ("apiKeyId") REFERENCES "ApiKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ApiUsage" ADD CONSTRAINT "ApiUsage_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ApiUsage" ADD CONSTRAINT "ApiUsage_apiKeyId_fkey" FOREIGN KEY ("apiKeyId") REFERENCES "ApiKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Leaderboard" ADD CONSTRAINT "Leaderboard_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Leaderboard" ADD CONSTRAINT "Leaderboard_freeUserId_fkey" FOREIGN KEY ("freeUserId") REFERENCES "FreeUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsageTracking" ADD CONSTRAINT "UsageTracking_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsageTracking" ADD CONSTRAINT "UsageTracking_subLicenseId_fkey" FOREIGN KEY ("subLicenseId") REFERENCES "SubLicense"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsageTracking" ADD CONSTRAINT "UsageTracking_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Installation" ADD CONSTRAINT "Installation_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Installation" ADD CONSTRAINT "Installation_apiKeyId_fkey" FOREIGN KEY ("apiKeyId") REFERENCES "ApiKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Installation" ADD CONSTRAINT "Installation_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Installation" ADD CONSTRAINT "Installation_freeUserId_fkey" FOREIGN KEY ("freeUserId") REFERENCES "FreeUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Purchase" ADD CONSTRAINT "Purchase_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Purchase" ADD CONSTRAINT "Purchase_packId_fkey" FOREIGN KEY ("packId") REFERENCES "Pack"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Purchase" ADD CONSTRAINT "Purchase_creditTransactionId_fkey" FOREIGN KEY ("creditTransactionId") REFERENCES "CreditTransaction"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Prompt" ADD CONSTRAINT "Prompt_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserUpvote" ADD CONSTRAINT "UserUpvote_promptId_fkey" FOREIGN KEY ("promptId") REFERENCES "Prompt"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCredit" ADD CONSTRAINT "UserCredit_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CreditTransaction" ADD CONSTRAINT "CreditTransaction_userCreditId_fkey" FOREIGN KEY ("userCreditId") REFERENCES "UserCredit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RedeemCode" ADD CONSTRAINT "RedeemCode_batchId_fkey" FOREIGN KEY ("batchId") REFERENCES "RedeemCodeBatch"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RedeemCode" ADD CONSTRAINT "RedeemCode_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductReview" ADD CONSTRAINT "ProductReview_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSubscription" ADD CONSTRAINT "UserSubscription_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSubscription" ADD CONSTRAINT "UserSubscription_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSubscription" ADD CONSTRAINT "UserSubscription_planId_fkey" FOREIGN KEY ("planId") REFERENCES "Plan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutoCommenterConfig" ADD CONSTRAINT "AutoCommenterConfig_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutoCommenterConfig" ADD CONSTRAINT "AutoCommenterConfig_licenseKeyId_fkey" FOREIGN KEY ("licenseKeyId") REFERENCES "LicenseKey"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutoCommenterHistory" ADD CONSTRAINT "AutoCommenterHistory_configId_fkey" FOREIGN KEY ("configId") REFERENCES "AutoCommenterConfig"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
