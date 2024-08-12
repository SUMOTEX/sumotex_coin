// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
pragma solidity ^0.8.0;

contract CrigenCoinFST is
    Initializable,
    ContextUpgradeable,
    ERC20Upgradeable,
    OwnableUpgradeable,
    PausableUpgradeable
{
    using SafeMath for uint256;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    uint256 private _initialSupply;
    address public sumoAddress;
    //Fund Manager is Danai Wellness in this situation
    address public fundManagerAddress;
    //Partner name is UBB
    address public partnerAddress;
    address public sstToken;
    string public sumoName;
    string public partnerName;
    string public fundManagerName;
    string public auditLink;
    uint256 public usdCost;
    IERC20Upgradeable public erc20Contract;
    IERC20Upgradeable public usdc;
    IERC20Upgradeable public smtx;
    struct Agreement{
        string link;
        uint256 tokenAmount;
        bool holding;
    }
    mapping(address => Agreement[]) public investorAgreement;
    mapping(address => bool) public blacklisted;

    function initialize() public initializer {
        __ERC20_init("Danai Wellness Coin", "CRIGEN RESOURCES LIMITED (LL18250)");
        __Ownable_init();
        __Pausable_init();
        _totalSupply = 350000 * 10**uint256(decimals());
        usdc = IERC20Upgradeable(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        //usdc = IERC20Upgradeable(0x07865c6E87B9F70255377e024ace6630C1Eaa37F);
        smtx = IERC20Upgradeable(0x102203517ce35AC5Cab9a2cda80DF03f26c7419b);
        sumoAddress = 0xA6F49C590A8e1AFbEbF5C245E1768435c7718bF6;
        fundManagerAddress = 0x3655c868CAfa3AA97803cC0aDeD6419a5EEB4ab2;
        partnerAddress = 0x3655c868CAfa3AA97803cC0aDeD6419a5EEB4ab2;
        partnerName = "UBB Investment Bank Limited";
        sumoName = "Sumolab";
        fundManagerName = "CRIGEN RESOURCES LIMITED (LL18250)";
        auditLink = "";
    }

    /**
     * @dev total number of tokens in existence
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function initialSupply() public view returns (uint256) {
        return _initialSupply;
    }

    /**
     * @dev transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */
    function transfer(address _to, uint256 _value)
        public
        override
        whenNotPaused
        returns (bool)
    {
        require(_to != address(0));
        require(blacklisted[msg.sender] != true);
        address owner = _msgSender();
        _transfer(owner, _to, _value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param amount uint256 the amount of tokens to be transferred
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override whenNotPaused returns (bool) {
        address spender = _msgSender();
        require(to != address(0));
        require(blacklisted[msg.sender] != true);
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function updateAuditedLink(string memory _newAuditLink) public onlyOwner {
        auditLink = _newAuditLink;
    }

    function updateSumoNameAddress(address _address) public onlyOwner {
        sumoAddress = _address;
    }
    function updateSumoName(string memory _sumoname) public onlyOwner {
        sumoName = _sumoname;
    }
    function updateFundManagerAddress(address _managerAddress) public onlyOwner {
        fundManagerAddress = _managerAddress;
    }
    function updateFundManagerName(string memory _managerName) public onlyOwner {
        fundManagerName = _managerName;
    }
    function updatePartnerAddress(address _partnerAddress) public onlyOwner {
        partnerAddress = _partnerAddress;
    }
    function updatePartnerName(string memory _partnerName) public onlyOwner {
        partnerName = _partnerName;
    }
    function getFundManager() public view returns (string memory theFundManager){
        return fundManagerName;
    }
    function getPartnerName() public view returns (string memory thePartnerName){
        return partnerName;
    }
    function updateUSDCAddress(address _usdcAddress) public onlyOwner {
        usdc=IERC20Upgradeable(_usdcAddress);
    }
    function updateSMTXAddress(address _smtxAddress) public onlyOwner {
        smtx=IERC20Upgradeable(_smtxAddress);
    }
    function getAgreements(address _investorAddress) public view returns(Agreement[] memory) {
        return investorAgreement[_investorAddress];
    }
   /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual override onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }
    
    function mint(address to, uint256 amount) public whenNotPaused onlyOwner {
        require(_initialSupply + amount <= _totalSupply);
        _mint(to, amount);
        _initialSupply += amount;
    }
    function purchaseWithETH(address to, uint256 amount,string memory _agreementLink) public payable whenNotPaused {
        require(_initialSupply + amount <= _totalSupply);
        uint256 comission;
        comission = (((msg.value) * 150) / 10000);
        _mint(to, amount);
        _initialSupply += amount;
        Agreement memory user= Agreement(_agreementLink,amount,true); 
        investorAgreement[to].push(user);
        uint256 netFund = msg.value - comission - comission;
        (bool success, ) = payable(sumoAddress).call{value: comission}("");
        (bool success2, ) = payable(partnerAddress).call{value: comission}("");
        (bool success3, ) = payable(fundManagerAddress).call{value: (netFund)}("");
        require(success);
        require(success2);
        require(success3);
    }
    function purchaseWithUSDC(address to, uint256 _amount,uint256 usdcAmount,string memory _agreementLink) public whenNotPaused {
        require(_initialSupply + _amount <= _totalSupply);
        uint256 comission;
        comission = ((usdcAmount * 150) / 10000);
        uint256 netFund = usdcAmount - comission - comission;
        usdc.transferFrom(
                msg.sender,
                fundManagerAddress,
                netFund
            );
        usdc.transferFrom(msg.sender, sumoAddress, comission);
        usdc.transferFrom(msg.sender, partnerAddress, comission);
        _mint(to, _amount);
        _initialSupply += _amount;
        Agreement memory user= Agreement(_agreementLink,_amount,true); 
        investorAgreement[to].push(user);
    }
    function purchaseWithSMTX(address to, uint256 _amount,uint256 smtxAmount,string memory _agreementLink) public whenNotPaused {
        require(_initialSupply + _amount <= _totalSupply);
        uint256 comission;
        comission = ((_amount * 150) / 10000);
        smtx.transferFrom(
                msg.sender,
                fundManagerAddress,
                smtxAmount - comission - comission
            );
        smtx.transferFrom(msg.sender, sumoAddress, comission);
        smtx.transferFrom(msg.sender, partnerAddress, comission);
        _mint(to, _amount);
        _initialSupply += _amount;
        Agreement memory user= Agreement(_agreementLink,_amount,true); 
        investorAgreement[to].push(user);
    }
    function sellToken(uint256 _tokenAmount,uint256 _amount) public whenNotPaused {
        usdc.transferFrom(fundManagerAddress, msg.sender, _amount);
        _burn(msg.sender, _tokenAmount);
        _initialSupply-=_tokenAmount;
    }
    function addblackListUser(address _blacklistUser)
        public
        whenNotPaused
        onlyOwner
    {
        blacklisted[_blacklistUser] = true;
    }

    function removeblackListUser(address _blacklistUser)
        public
        whenNotPaused
        onlyOwner
    {
        blacklisted[_blacklistUser] = false;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}
