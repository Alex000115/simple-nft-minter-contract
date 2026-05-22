const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contract with account:", deployer.address);

  const NFTMinter = await hre.ethers.getContractFactory("NFTMinter");
  const nft = await NFTMinter.deploy(
    "Web3 Genesis", 
    "W3G", 
    "ipfs://QmExampleCID/"
  );

  await nft.waitForDeployment();
  console.log("NFT Contract deployed to:", await nft.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
