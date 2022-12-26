// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const marketplace = await ethers.getContractFactory('SST');
  console.log('Deploying FSSTST...');
  const box = await upgrades.deployProxy(marketplace, [49],{ initializer: 'initialize' });
  await box.deployed();
  console.log(box.address," box(proxy) address")
  console.log(await upgrades.erc1967.getImplementationAddress(box.address)," getImplementationAddress")
  console.log(await upgrades.erc1967.getAdminAddress(box.address)," getAdminAddress")   
  console.log('SST deployed to:', box.address);
}
//TESTNET goerli
//0x7bf762D1Ded287068Fba536AF3ee96D79B0807Bf
//Prod
//0x2A0827A41b36C0f5Cb5BD4AD7bf84515cb9d7bd7  box(proxy) address
// 0x629b8deaC1a755eF0fED921Bc252f823244d6882  getImplementationAddress
// 0x0000000000000000000000000000000000000000  getAdminAddress
// SST deployed to: 0x2A0827A41b36C0f5Cb5BD4AD7bf84515cb9d7bd7
main();