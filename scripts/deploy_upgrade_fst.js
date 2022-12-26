// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const fst = await ethers.getContractFactory("HomevestCoinFST");
  const box = await upgrades.upgradeProxy("0xC69617b499f664d69484D211c57AbcBDaa42398B", fst);
  await box.deployed();
}
//Goerli
// 0xC69617b499f664d69484D211c57AbcBDaa42398B  box(proxy) address
// 0x6aC33BBB54743d9F4FeB4656609C12870898AEd7  getImplementationAddress
// 0x34514e2c91d4917745A18F53C7bbeF38596c52f3  getAdminAddress
// HomevestCoinFST deployed to: 0xC69617b499f664d69484D211c57AbcBDaa42398B
main();