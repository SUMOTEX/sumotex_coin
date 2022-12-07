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
//0x7bf762D1Ded287068Fba536AF3ee96D79B0807Bf
main();