require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('@openzeppelin/hardhat-upgrades');

module.exports = {
  solidity: "0.8.4",
  networks: {
    ropsten: {
      url: 'https://ropsten.infura.io/v3/b02fa7c04bbf4d39b20c69fe71d5ca94',
      accounts: ['']
    }
  },
  etherscan: {
    apiKey: "9FR6ZV8R74CHWB97KP6QW1W3HJ9PPDJQBP"
  }
};