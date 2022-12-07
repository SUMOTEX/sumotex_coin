// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const marketplace = await ethers.getContractFactory('FST');
  console.log('Deploying FST...');
  const box = await upgrades.deployProxy(marketplace, [49],{ initializer: 'initialize' });
  await box.deployed();
  console.log(box.address," box(proxy) address")
  console.log(await upgrades.erc1967.getImplementationAddress(box.address)," getImplementationAddress")
  console.log(await upgrades.erc1967.getAdminAddress(box.address)," getAdminAddress")   
  console.log('FST deployed to:', box.address);
}
//0x51E6422DC9cc77b19A04D13D75a607194Aba594C
main();