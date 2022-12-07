// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const smtx = await ethers.getContractFactory('SMTXMultiSwap');
  console.log('Deploying Multi swap...');
  const box = await smtx.deploy();
  box.deployed();
  console.log(box.address,"Add") 
  console.log('SWAP deployed to:', box.address);
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });