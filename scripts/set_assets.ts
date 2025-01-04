import { supportedAssets } from "./supported_assets";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  await prisma.$transaction(
    Object.values(supportedAssets).map((s) =>
      prisma.asset.upsert({
        where: { id: s.symbol },
        create: { id: s.symbol, ...s },
        update: s,
      })
    )
  );
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
