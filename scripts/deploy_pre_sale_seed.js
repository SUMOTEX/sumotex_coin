// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const smtx = await ethers.getContractFactory('PreSaleSeedInvestorSMTX');
  console.log('Deploying PreSaleSeedInvestorSMTX...');
  const box = await smtx.deploy();
  box.deployed();
  console.log(box.address," PreSaleSeedInvestorSMTX lock (proxy) address") 
  console.log('PreSaleSeedInvestorSMTX deployed to:', box.address);
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });