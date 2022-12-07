// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract SST is
    Initializable,
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable,
    ERC721URIStorageUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable,
    ERC721BurnableUpgradeable,
    UUPSUpgradeable
{
    using SafeERC20Upgradeable for IERC20Upgradeable;
    bool private initialized;
    uint256 public maxSupply;
    mapping(uint256 => address) public firstFuseAddress;
    address[] public whiteListedAuditor;
    uint256 public x;

    function initialize(uint256 _x) public initializer {
        require(!initialized, "Contract instance has already been initialized");
        initialized = true;
        __ERC721_init("SST-Foundation", "SST-Foundation");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Pausable_init();
        __Ownable_init();
        __ERC721Burnable_init();
        __UUPSUpgradeable_init();
        x = _x;
        maxSupply = 10000000000;
    }

    function addNFTContract(address _auditorAddress) public onlyOwner {
        whiteListedAuditor.push(_auditorAddress);
    }

    function deleteNFTContract(address _auditorAddress) public onlyOwner {
        for (uint256 i = 0; i < whiteListedAuditor.length; i++) {
            if (whiteListedAuditor[i] == _auditorAddress) {
                delete whiteListedAuditor[i];
            }
        }
    }

    function getNFTContract() public view returns (address[] memory) {
        return whiteListedAuditor;
    }

    function checkAuditor(address _auditorAddress) public view returns (bool) {
        for (uint256 i = 0; i < whiteListedAuditor.length; i++) {
            if (whiteListedAuditor[i] == _auditorAddress) {
                return true;
            }
        }
        return false;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function updateTokenURI(uint256 tokenId, string memory _uri)
        public
        onlyOwner
    {
        _setTokenURI(tokenId, _uri);
    }

    function getFirstMinterInfo(uint256 tokenId)
        public
        view
        returns (address firstMinter)
    {
        return firstFuseAddress[tokenId];
    }

    function safeMint(address _to, string memory theURI) public onlyOwner {
        uint256 supply = totalSupply();
        _safeMint(_to, supply + 1);
        _setTokenURI(supply + 1, theURI);
        firstFuseAddress[supply + 1] = msg.sender;
    }

    function safeMintAuditor(address _to, string memory theURI) public {
        require(checkAuditor(msg.sender) == true, "Auditor not verified");
        uint256 supply = totalSupply();
        _safeMint(_to, supply + 1);
        _setTokenURI(supply + 1, theURI);
        firstFuseAddress[supply + 1] = msg.sender;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    )
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        whenNotPaused
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    // The following functions are overrides required by Solidity.
    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Failure to send");
    }
}
