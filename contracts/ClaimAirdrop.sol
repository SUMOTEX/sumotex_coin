// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract ClaimAirdropSMTX is ReentrancyGuardUpgradeable, OwnableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using SafeMath for uint256;
    CountersUpgradeable.Counter private _itemIds;
    uint256 public x;
    bool private initialized;
    bool public pause;
    uint256[] public ogSumoList;
    uint256[] public xSumoList;

    function initialize() public initializer {
        require(!initialized, "Contract instance has already been initialized");
        initialized = true;
        //Set Owner
        __Ownable_init();
        x = 42;
        pause = false;
    }
    struct AirdropList {
        uint256 itemId;
        address owner;
        uint256 amount;
        bool claimed;
        uint256[] xSumoArray;
        uint256[] ogSumoArray;
    }

    mapping(uint256 => AirdropList) private idToAirdropList;

    event ClaimAirdropCreated(
        uint256 indexed itemId,
        address owner,
        uint256 amount,
        bool claimed,
        uint256[] xSumoArray,
        uint256[] ogSumoArray
    );

    function getAirdropItem(address claimAddress)
        public
        view
        returns (AirdropList memory)
    {
        uint256 itemCount = _itemIds.current();

        AirdropList[] memory items = new AirdropList[](itemCount);
        for (uint256 i = 0; i <= itemCount; i++) {
            if (idToAirdropList[i].owner==claimAddress){
                return idToAirdropList[i];
            }
        }
    }

    function createAirdropItem(
        uint256 amount,
        uint256[] memory _xSumoList,
        uint256[] memory _ogSumoList

    ) public nonReentrant {
        require(!pause);
        _itemIds.increment();
        uint256 itemId = _itemIds.current();
        // uint256 xSumoLength = _xSumoList.length;
        // uint256 ogSumoLength = _ogSumoList.length;
        // uint256[] memory xSumoItems = new uint[](xSumoLength);
        // uint256[] memory OgSumoItems = new uint[](ogSumoLength);
        // xSumoItems = _xSumoList;
        // OgSumoItems = _ogSumoList;
        idToAirdropList[itemId] = AirdropList(itemId,msg.sender, amount,false,_xSumoList,_ogSumoList);
        for (uint256 i = 0; i < _ogSumoList.length; i++) {
            ogSumoList.push(_ogSumoList[i]);
        }
        for (uint256 i = 0; i < _xSumoList.length; i++) {
            xSumoList.push(_xSumoList[i]);
        }
        //IERC721Upgradeable(nftContract).transferFrom(msg.sender, address(this), tokenId);
        emit ClaimAirdropCreated(itemId,msg.sender, amount,false,_xSumoList, _ogSumoList);
    }
    function fetchMyAirdrop() public view returns (AirdropList[] memory) {
        uint256 totalItemCount = _itemIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToAirdropList[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        }

        AirdropList[] memory items = new AirdropList[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToAirdropList[i + 1].owner == msg.sender) {
                uint256 currentId = idToAirdropList[i + 1].itemId;
                AirdropList storage currentItem = idToAirdropList[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
    function returnXSumoList()public view returns(uint256[] memory){
        return xSumoList;
    }
    function returnOGSumoList() public view returns(uint256[] memory){
        return ogSumoList;
    }
    function updateAirdropItem(uint256 _itemId,address claimAddress) 
        public
        onlyOwner
        returns (AirdropList memory)
    {
        uint256 itemCount = _itemIds.current();

        AirdropList[] memory items = new AirdropList[](itemCount);
        for (uint256 i = 0; i <= itemCount; i++) {
            if (idToAirdropList[i].owner==claimAddress && idToAirdropList[i].itemId==_itemId){
                idToAirdropList[i].claimed=true;
            }
        }
    }
}
