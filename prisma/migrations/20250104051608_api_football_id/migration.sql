-- DropForeignKey
ALTER TABLE "FootballScoreOracle" DROP CONSTRAINT "FootballScoreOracle_matchId_fkey";

-- AddForeignKey
ALTER TABLE "FootballScoreOracle" ADD CONSTRAINT "FootballScoreOracle_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "FootballMatch"("apiFootballId") ON DELETE RESTRICT ON UPDATE CASCADE;
