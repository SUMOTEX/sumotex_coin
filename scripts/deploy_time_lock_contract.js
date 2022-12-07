// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const smtx = await ethers.getContractFactory('LinearTimeLockSMTX');
  console.log('Deploying LinearTimeLockSMTX...');
  const box = await smtx.deploy();
  box.deployed();
  console.log(box.address," Linear lock (proxy) address") 
  console.log('Timelock deployed to:', box.address);
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });