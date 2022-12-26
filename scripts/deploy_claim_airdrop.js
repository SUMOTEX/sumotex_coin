// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const smtx = await ethers.getContractFactory('AirdropTimeLockSMTX');
  console.log('Deploying ClaimAirdropSMTX swap...');
  const box = await smtx.deploy();
  box.deployed();
  console.log(box.address,"Add") 
  console.log('ClaimAirdropSMTX deployed to:', box.address);
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });


//goerli
//0x7d1E93251ad4141bCa576E0818B9A63A9e4176D4
//mainnet
//ClaimAirdropSMTX deployed to: 0xC4513C579bC83A19Ea52bE9Bd0BB3998cc2f0397