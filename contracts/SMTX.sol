// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
pragma solidity ^0.8.4;

contract SMTX is
    Initializable,
    ContextUpgradeable,
    ERC20Upgradeable,
    OwnableUpgradeable
{
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    function __ERC20_init() internal initializer {
        __Context_init_unchained();
        __ERC20_init_unchained();
    }

    function __ERC20_init_unchained() internal initializer {
        _name = 'SUMOTEX';
        _symbol = 'SMTX';
        _decimals = 18;
       
    }
    function mint(address to, uint amount) external onlyOwner{
         _mint(to,amount);
    }

}
