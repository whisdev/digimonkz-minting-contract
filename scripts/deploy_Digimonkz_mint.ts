import { ethers, upgrades } from "hardhat";

const baseURI ="https://endworld-backend.vercel.app/nft/metadata/" ;
const admin = "0x30f80866B3bEeDFd5f5488440D9e724BfC079964";

async function main() {

  const DigiMonkzMinting = await ethers.getContractFactory("DigiMonkzMinting");
  console.log("Deploying DigiMonkz...");
  
  const digiMonkzMinting = await upgrades.deployProxy(DigiMonkzMinting, [baseURI, admin],{initializer: "initialize"});
  console.log(digiMonkzMinting, "================================");
  
  console.log("before depolyed()");
  await digiMonkzMinting.waitForDeployment();

  console.log("Contract deployed to address: ", await digiMonkzMinting.getAddress());
}

async function upgrade1() {
  const DigiMonkzMinting = await ethers.getContractFactory('DigiMonkzMinting');
  console.log("Upgrading Box...");
  await upgrades.upgradeProxy("0xCdc376D63A73898524c3Ae7b5f5A1B286E24fd4c", DigiMonkzMinting);
  console.log("DigiMonkz upgraded");
}

async function upgrade2() {
  const DigiMonkzMinting = await ethers.getContractFactory('DigiMonkzMinting');
  console.log("Upgrading Box...");
  await upgrades.upgradeProxy("0x1Db3BdfB0B1b35F2ee43387c5185516e9E870C57", DigiMonkzMinting);
  console.log("DigiMonkz upgraded");
}

upgrade1().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
upgrade2().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
