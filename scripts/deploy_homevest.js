// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const fst = await ethers.getContractFactory('HomevestCoinFST');
  console.log('Deploying HomevestCoinFST ...');
  const box = await upgrades.deployProxy(fst, { initializer: 'initialize' });
  await box.deployed();
  console.log(box.address," box(proxy) address")
  console.log(await upgrades.erc1967.getImplementationAddress(box.address)," getImplementationAddress")
  console.log(await upgrades.erc1967.getAdminAddress(box.address)," getAdminAddress")   
  console.log('HomevestCoinFST deployed to:', box.address);
}
//Goerli
// 0xC69617b499f664d69484D211c57AbcBDaa42398B  box(proxy) address
// 0x6aC33BBB54743d9F4FeB4656609C12870898AEd7  getImplementationAddress
// 0x34514e2c91d4917745A18F53C7bbeF38596c52f3  getAdminAddress
// HomevestCoinFST deployed to: 0xC69617b499f664d69484D211c57AbcBDaa42398B

//Prod
// Deploying HomevestCoinFST ...
// 0x99Ad77b8FE19c07e95C44C004184A155e59DdecA  box(proxy) address
// 0x2Ac2f1b3fd774269462966de1f0b60e988622006  getImplementationAddress
// 0x29D2e705dC22E8F2c7173524EF3C99CF5DE1F626  getAdminAddress
// HomevestCoinFST deployed to: 0x99Ad77b8FE19c07e95C44C004184A155e59DdecA
main();