// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const smtx = await ethers.getContractFactory('AirdropTimeLockSMTX');
  console.log('Deploying AirdropTimeLockSMTX swap...');
  const box = await smtx.deploy();
  box.deployed();
  console.log(box.address,"Add") 
  console.log('AirdropTimeLockSMTX deployed to:', box.address);
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });