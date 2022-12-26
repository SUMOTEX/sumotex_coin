// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const fst = await ethers.getContractFactory('CrigenCoinFST');
  console.log('Deploying CrigenCoinFST ...');
  const box = await upgrades.deployProxy(fst, { initializer: 'initialize' });
  await box.deployed();
  console.log(box.address," box(proxy) address")
  console.log(await upgrades.erc1967.getImplementationAddress(box.address)," getImplementationAddress")
  console.log(await upgrades.erc1967.getAdminAddress(box.address)," getAdminAddress")   
  console.log('CrigenCoinFST deployed to:', box.address);
}
//Goerli
// 0xA3021870f92AF52dD1286f53350e69f7ABD938c4  box(proxy) address
// 0x5Dc50101fAE5dAC7B1cca2d7e7f07Bb26cAf2cd0  getImplementationAddress
// 0x29D2e705dC22E8F2c7173524EF3C99CF5DE1F626  getAdminAddress
// CrigenCoinFST deployed to: 0xA3021870f92AF52dD1286f53350e69f7ABD938c4

//Prod
// 0x26E60c1A2Ea2505F0299E62eA794c0C0dE3670D6  box(proxy) address
// 0xe7c35D36D46CaFE7EFe7D3764A1BEa0ae2733D24  getImplementationAddress
// 0x29D2e705dC22E8F2c7173524EF3C99CF5DE1F626  getAdminAddress
// CrigenCoinFST deployed to: 0x26E60c1A2Ea2505F0299E62eA794c0C0dE3670D6
main();