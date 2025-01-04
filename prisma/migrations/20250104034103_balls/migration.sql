-- CreateEnum
CREATE TYPE "ChallengeState" AS ENUM ('open', 'closed', 'cancelled', 'matured');

-- CreateEnum
CREATE TYPE "DataProvidedStatus" AS ENUM ('waiting', 'proposed', 'accepted', 'contested');

-- CreateEnum
CREATE TYPE "Sport" AS ENUM ('football');

-- CreateEnum
CREATE TYPE "MatchStatus" AS ENUM ('cancelled', 'upcoming', 'ongoing', 'past');

-- CreateTable
CREATE TABLE "ChallengeTopic" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ChallengeTopic_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Challenge" (
    "id" INTEGER NOT NULL,
    "state" "ChallengeState" NOT NULL,
    "isMulti" BOOLEAN NOT NULL,
    "outcome" TEXT,
    "transaction" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Challenge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChallengeEvent" (
    "id" SERIAL NOT NULL,
    "params" TEXT NOT NULL,
    "paramsJson" JSONB NOT NULL,
    "topicId" TEXT NOT NULL,
    "maturity" INTEGER NOT NULL,
    "outcome" TEXT,
    "status" "DataProvidedStatus" NOT NULL DEFAULT 'waiting',
    "challengeId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ChallengeEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChallengeOption" (
    "id" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "hex" TEXT NOT NULL,
    "challengeId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChallengeOption_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ParticipantStake" (
    "id" SERIAL NOT NULL,
    "amount" BIGINT NOT NULL,
    "quantity" BIGINT NOT NULL,
    "price" BIGINT NOT NULL,
    "address" TEXT NOT NULL,
    "transaction" TEXT NOT NULL,
    "challengeId" INTEGER NOT NULL,
    "challengeOptionId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ParticipantStake_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ParticipantWithdrawal" (
    "id" SERIAL NOT NULL,
    "amount" BIGINT NOT NULL,
    "quantity" BIGINT NOT NULL,
    "price" BIGINT NOT NULL,
    "transaction" TEXT NOT NULL,
    "challengeId" INTEGER NOT NULL,
    "challengeOptionId" TEXT NOT NULL,

    CONSTRAINT "ParticipantWithdrawal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GeneralStatement" (
    "id" SERIAL NOT NULL,
    "statement" TEXT NOT NULL,
    "options" JSONB NOT NULL,
    "published" BOOLEAN NOT NULL DEFAULT false,
    "resolution" TEXT NOT NULL,
    "outcome" TEXT,
    "status" "DataProvidedStatus" NOT NULL DEFAULT 'waiting',
    "maturity" INTEGER NOT NULL,

    CONSTRAINT "GeneralStatement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FootballScoreOracle" (
    "id" SERIAL NOT NULL,
    "matchId" INTEGER NOT NULL,
    "sport" "Sport" NOT NULL,
    "homeScore" INTEGER,
    "awayScore" INTEGER,
    "maturity" INTEGER NOT NULL,
    "status" "DataProvidedStatus" NOT NULL DEFAULT 'waiting',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FootballScoreOracle_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssetPriceOracle" (
    "id" SERIAL NOT NULL,
    "assetSymbol" TEXT NOT NULL,
    "maturity" INTEGER NOT NULL,
    "price" INTEGER,
    "status" "DataProvidedStatus" NOT NULL DEFAULT 'waiting',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AssetPriceOracle_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FootballMatch" (
    "id" SERIAL NOT NULL,
    "apiFootballId" INTEGER NOT NULL,
    "homeTeamId" INTEGER NOT NULL,
    "homeTeamName" VARCHAR(512) NOT NULL,
    "awayTeamId" INTEGER NOT NULL,
    "awayTeamName" VARCHAR(512) NOT NULL,
    "leagueId" INTEGER NOT NULL,
    "leagueName" VARCHAR(512) NOT NULL,
    "leagueCountry" VARCHAR(512) NOT NULL,
    "startsOn" TIMESTAMP(3) NOT NULL,
    "status" "MatchStatus" NOT NULL,
    "venue" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FootballMatch_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Asset" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "symbol" TEXT NOT NULL,
    "icon" TEXT NOT NULL,

    CONSTRAINT "Asset_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "ChallengeTopic_name_key" ON "ChallengeTopic"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Challenge_transaction_key" ON "Challenge"("transaction");

-- CreateIndex
CREATE UNIQUE INDEX "ParticipantStake_transaction_key" ON "ParticipantStake"("transaction");

-- CreateIndex
CREATE UNIQUE INDEX "ParticipantWithdrawal_transaction_key" ON "ParticipantWithdrawal"("transaction");

-- CreateIndex
CREATE UNIQUE INDEX "FootballMatch_apiFootballId_key" ON "FootballMatch"("apiFootballId");

-- CreateIndex
CREATE INDEX "FootballMatch_leagueName_idx" ON "FootballMatch"("leagueName");

-- CreateIndex
CREATE INDEX "FootballMatch_homeTeamName_idx" ON "FootballMatch"("homeTeamName");

-- CreateIndex
CREATE INDEX "FootballMatch_awayTeamName_idx" ON "FootballMatch"("awayTeamName");

-- CreateIndex
CREATE INDEX "FootballMatch_leagueCountry_idx" ON "FootballMatch"("leagueCountry");

-- AddForeignKey
ALTER TABLE "ChallengeEvent" ADD CONSTRAINT "ChallengeEvent_topicId_fkey" FOREIGN KEY ("topicId") REFERENCES "ChallengeTopic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChallengeEvent" ADD CONSTRAINT "ChallengeEvent_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES "Challenge"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChallengeOption" ADD CONSTRAINT "ChallengeOption_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES "Challenge"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipantStake" ADD CONSTRAINT "ParticipantStake_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES "Challenge"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipantStake" ADD CONSTRAINT "ParticipantStake_challengeOptionId_fkey" FOREIGN KEY ("challengeOptionId") REFERENCES "ChallengeOption"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipantWithdrawal" ADD CONSTRAINT "ParticipantWithdrawal_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES "Challenge"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipantWithdrawal" ADD CONSTRAINT "ParticipantWithdrawal_challengeOptionId_fkey" FOREIGN KEY ("challengeOptionId") REFERENCES "ChallengeOption"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FootballScoreOracle" ADD CONSTRAINT "FootballScoreOracle_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "FootballMatch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssetPriceOracle" ADD CONSTRAINT "AssetPriceOracle_assetSymbol_fkey" FOREIGN KEY ("assetSymbol") REFERENCES "Asset"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
