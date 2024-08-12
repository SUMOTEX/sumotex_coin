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

contract FST is
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
    address public sumoAddress;
    address public fundManagerAddress;
    address public partnerAddress;
    string public sumoName;
    string public partnerName;
    string public fundManagerName;
    string public auditedLink;
    uint256 public cost;
    uint256 public usdCost;
    uint256 public presaleCost;
    uint256 public presaleAmount;
    uint256 public maxMintAmount;
    mapping(uint256 => address) public firstFuseAddress;
    mapping(address => bool) public whitelisted;
    mapping(address => bool) public presaleWallets;
    // ERC20 contract address
    IERC20Upgradeable public erc20Contract;
    IERC20Upgradeable public usdc;
    IERC20Upgradeable public smtx;
    uint256 public x;

    function initialize(uint256 _x) public initializer {
        require(!initialized, "Contract instance has already been initialized");
        initialized = true;
        __ERC721_init("FST-Homevest", "FST-Homevest");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Pausable_init();
        __Ownable_init();
        __ERC721Burnable_init();
        __UUPSUpgradeable_init();
        x = _x;
        //To do change to 1000, currently at 0.01wei
        cost = 10000000000000000 wei;
        usdCost=10;
        maxSupply = 2500;
        maxMintAmount = 2500;
        sumoAddress = 0xa359F9524a4986B5dc180feDFaC9c0ED941b0615;
        fundManagerAddress = 0x4eB30B34381348ba5FCeE47F65f93489E71c3452;
        partnerAddress = 0x66975cf95CFd6b8744dBd13589aFbC91B0bB9D3E;
        partnerName = "UBB Private Limited";
        sumoName = "SUMOLAB Private Limited ";
        fundManagerName = "Homevest Private Limited";
        auditedLink = "";
        //SMTX TEST TOKEN = 0x3C1E3B0Ad165A4bB19aee73eAddC5919996d4E8B
        //USDC TEST TOKEN = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F
        usdc = IERC20Upgradeable(0x07865c6E87B9F70255377e024ace6630C1Eaa37F);
        smtx = IERC20Upgradeable(0x3C1E3B0Ad165A4bB19aee73eAddC5919996d4E8B);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function updateCreatorAdd(address _creatorAddress) public onlyOwner {
        sumoAddress = _creatorAddress;
    }

    function updateAuditedLink(string memory _newAuditLink) public onlyOwner {
        auditedLink = _newAuditLink;
    }

    function partnerNameAdd(address _creatorAddress) public onlyOwner {
        sumoAddress = _creatorAddress;
    }

    function updateFundManagerAdd(address _managerAddress) public onlyOwner {
        fundManagerAddress = _managerAddress;
    }
    function updateFundManagerName(string memory _managerName) public onlyOwner {
        fundManagerName = _managerName;
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
    function getUSDCost() public view returns (uint256 theCost){
        return usdCost;
    }
    function getFundManager() public view returns (string memory theFundManager){
        return fundManagerName;
    }
    
    function safeMintViaSMTX(
        address _to,
        uint256 _mintAmount,
        string memory theURI,
        uint256 smtxAmount
    ) public payable {
        uint256 supply = totalSupply();
        require(_mintAmount > 0);
        require(supply + _mintAmount <= maxSupply);
        uint256 comission;
        if (msg.sender != owner()) {
            //general public
            comission = ((((10 * (10**18)) * _mintAmount) * 150) / 10000);
            smtx.transferFrom(
                msg.sender,
                fundManagerAddress,
                smtxAmount - comission - comission
            );
            smtx.transferFrom(msg.sender, sumoAddress, comission);
            smtx.transferFrom(msg.sender, partnerAddress, comission);
        }
        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(_to, supply + i);
            _setTokenURI(supply + i, theURI);
            firstFuseAddress[supply + i] = msg.sender;
        }
    }

    function safeMintViaUSDC(
        address _to,
        uint256 _mintAmount,
        string memory theURI,
        uint256 usdcAmount
    ) public payable {
        uint256 supply = totalSupply();
        require(_mintAmount > 0);
        require(supply + _mintAmount <= maxSupply);
        uint256 comission;
        if (msg.sender != owner()) {
            //general public
            //testing for tranche = 1000USD
            require(usdcAmount >= (10*(10**6)) * _mintAmount,"Insufficient Amount");
            comission = ((((10*(10**6)) * _mintAmount) * 150) / 10000);
            usdc.transferFrom(
                msg.sender,
                fundManagerAddress,
                usdcAmount - comission - comission
            );
            usdc.transferFrom(msg.sender, sumoAddress, comission);
            usdc.transferFrom(msg.sender, partnerAddress, comission);
        }
        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(_to, supply + i);
            _setTokenURI(supply + i, theURI);
            firstFuseAddress[supply + i] = msg.sender;
        }
    }

    function safeMint(
        address _to,
        uint256 _mintAmount,
        string memory theURI
    ) public payable {
        uint256 supply = totalSupply();
        require(_mintAmount > 0);
        require(supply + _mintAmount <= maxSupply);
        if(msg.sender!=owner()){
            require(msg.value>= (cost * _mintAmount),"Insufficient amount");
        }
        uint256 comission;
        comission = (((msg.value) * 150) / 10000);
        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(_to, supply + i);
            _setTokenURI(supply + i, theURI);
            firstFuseAddress[supply + i] = msg.sender;
        }
        (bool success, ) = payable(sumoAddress).call{value: comission}("");
        (bool success2, ) = payable(partnerAddress).call{value: comission}(
            ""
        );
        require(success);
        require(success2);
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

    function burn(uint256 tokenId) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: caller is not token owner or approved"
        );
        _burn(tokenId);
    }

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

    function whitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = true;
    }

    function removeWhitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = false;
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdrawAsFundManager() public payable {
        require(
            msg.sender == fundManagerAddress,
            "You are not the Fund Manager"
        );
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Failure to send");
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Failure to send");
    }
}
