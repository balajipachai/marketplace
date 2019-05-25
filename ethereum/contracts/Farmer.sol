/**
* Farmer contract.
* A farmer can be a buyer or seller.
*/
pragma solidity 0.5.2;
import "./Cattle.sol";
import "./Auction.sol";
import "./Government.sol";
import "./Milk.sol";
import "./openZeppelin/utils/Address.sol";

contract Farmer {
    using Address for address;
    Cattle public cattleContract;
    Auction public auctionContract;
    Government public governmentContract;
    Milk public milkContract;
    address GOV_ADDRESS;

    /**
    * @dev Constructor function
    * @param _cattleContract The cattle contract address
    */
    constructor(address _cattleContract, address _auctionContract, address _governmentContract, address _milkContract) public {
        require(_cattleContract != address(0), "CATTLE_CONTRACT_ADDRESS_IS_ZERO_ADDRESS");
        require(_cattleContract.isContract(), "CATTLE_NOT_A_CONTRACT_ADDRESS");
        require(_auctionContract != address(0), "AUCTION_CONTRACT_ADDRESS_IS_ZERO_ADDRESS");
        require(_auctionContract.isContract(), "AUCTION_NOT_A_CONTRACT_ADDRESS");
        require(_governmentContract != address(0), "GOVERNMENT_CONTRACT_ADDRESS_IS_ZERO_ADDRESS");
        require(_governmentContract.isContract(), "GOVERNMENT_NOT_A_CONTRACT_ADDRESS");
        require(_milkContract != address(0), "MILK_CONTRACT_ADDRESS_IS_ZERO_ADDRESS");
        require(_milkContract.isContract(), "MILK_NOT_A_CONTRACT_ADDRESS");

        cattleContract = Cattle(_cattleContract);
        auctionContract = Auction(_auctionContract);
        governmentContract = Government(_governmentContract);
        milkContract = Milk(_milkContract);
        GOV_ADDRESS = _governmentContract;
    }

    event LogCattleRegistration(address indexed owner, string cattleDetails, uint256 timestamp);
    event LogSellCattle(address indexed owner, uint256 indexed basePrice, uint256 timestamp);
    event LogBuyCattle(address indexed buyer, uint256 indexed price, uint256 timestamp);

    event LogMilkRegistration(address indexed owner, string milkDetails, uint256 timestamp);
    event LogSellMilk(address indexed owner, uint256 indexed basePrice, uint256 timestamp);
    event LogBuyMilk(address indexed buyer, uint256 indexed price, uint256 timestamp);

    mapping(address => mapping(uint256 => bool)) public isCattleVerifiedByGov;
    mapping(address => mapping(uint256 => bool)) public isMilkVerifiedByGov;

    modifier onlyCattleOwner(uint256 _cattleId) {
        address cattleOwner = cattleContract.ownerOf(_cattleId);
        require(msg.sender == cattleOwner, "NON_OWNER_CANNOT_SELL_CATTLE");
        _;
    }

    modifier onlyMilkOwner(uint256 _milkId) {
        address milkOwner = milkContract.ownerOf(_milkId);
        require(msg.sender == milkOwner, "NON_OWNER_CANNOT_SELL_MILK");
        _;
    }

    modifier onlyGovernment() {
        require(msg.sender == GOV_ADDRESS, "CALLER_IS_NOT_GOVERNMENT");
        _;
    }

    /**
    * @dev Function that registers a Cattle on the Blockchain
    * @param to address to whom the cattle belongs
    * @param cattleDetails string hash of cattle details
    */
    function registerCattle(address to, string memory cattleDetails) public {
        cattleContract.cattleRegistration(to, cattleDetails);
        //sent for verification by government
        uint256 cattleId = cattleContract.getNoOfCattle(to);
        isCattleVerifiedByGov[to][cattleId] = governmentContract.verifyCattle(cattleId);
        emit LogCattleRegistration(to, cattleDetails, block.timestamp);
    }

    function registerMilk(address to, string memory milkDetails) public {
        milkContract.milkRegistration(to, milkDetails);
        //sent for verification by government
        uint256 milkId = milkContract.getNoOfRegisteredMilk(to);
        isMilkVerifiedByGov[to][milkId] = governmentContract.verifyMilk(milkId);
        emit LogMilkRegistration(to, milkDetails, block.timestamp);
    }

    /**
    * @dev Function that stores the verification status of the cattle by the government
    */
    function setVerificationStatus (uint256 _cattleId) onlyGovernment public {
        //Later on when actual verification flow will be implemented then add code
    }

    /**
    * @dev Function that invokes sell cattle
    * @param cattleId uint256 The cattle ID
    * @param auctionStartTimestamp Timestamp when to start the auction
    * @param auctionEndTimestamp Timestamp when to end the auction
    */
    function sellCattle(
        uint256 cattleId,
        uint256 basePrice,
        uint256 auctionStartTimestamp,
        uint256 auctionEndTimestamp
    ) onlyCattleOwner(cattleId) public {
        require(cattleContract.exists(cattleId), "CATTLE_ID_DO_NOT_EXISTS");
        require(isCattleVerifiedByGov[msg.sender][cattleId], "CATTLE_IS_NOT_VERIFIED_YET_BY_GOVERNMENT");
        //Call auction contract to set auction for above cattleId
        auctionContract.auctionCattle(msg.sender, cattleId, basePrice, auctionStartTimestamp, auctionEndTimestamp);
        emit LogSellCattle(msg.sender, basePrice, block.timestamp);
    }

    function sellMilk(
        uint256 milkId,
        uint256 basePrice,
        uint256 auctionStartTimestamp,
        uint256 auctionEndTimestamp
    ) onlyMilkOwner(milkId) public {
        require(milkContract.exists(milkId), "MILK_ID_DO_NOT_EXISTS");
        require(isMilkVerifiedByGov[msg.sender][milkId], "MILK_IS_NOT_VERIFIED_YET_BY_GOVERNMENT");
        //Call auction contract to set auction for above cattleId
        auctionContract.auctionMilk(msg.sender, milkId, basePrice, auctionStartTimestamp, auctionEndTimestamp);
        emit LogSellMilk(msg.sender, basePrice, block.timestamp);
    }

    /**
    * @dev Function that sets the bidAmount for the Cattle that is being put on sale
    * @param cattleId uint256 The cattle ID that is being put up for sale
    */
    function buyCattle(address buyer, uint256 cattleId, uint256 bidAmount) public {
        //Call auction contract's bidAmountForCattle function
        auctionContract.bidForCattle(buyer, cattleId, bidAmount);
        emit LogBuyCattle(buyer, bidAmount, block.timestamp);
    }

    function buyMilk(address buyer, uint256 milkId, uint256 bidAmount) public {
        //Call auction contract's bidAmountForMilk function
        auctionContract.bidForMilk(buyer, milkId, bidAmount);
        emit LogBuyMilk(buyer, bidAmount, block.timestamp);
    }
    /**
    * @dev Function that gets the cattle details
    * @param cattleId uint256 The cattle ID whose details has to be fetched
    */
    function getCattleDetails(uint cattleId) public view returns (string memory cattleDetails) {
        return cattleContract.tokenURI(cattleId);
    }

    function getMilkDetails(uint milkId) public view returns (string memory milkDetails) {
        return milkContract.tokenURI(milkId);
    }
}
