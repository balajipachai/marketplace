/**
* Farmer contract.
* A farmer can be a buyer or seller.
*/
pragma solidity 0.5.0;
import "./Cattle.sol";
import "./Auction.sol";
import "./Government.sol";

contract Farmer {
    Cattle public cattleContract;
    Auction public auctionContract;
    Government public governmentContract;

    event LogCattleRegistration(address indexed owner, bytes32 indexed cattleDetails, uint256 timestamp);
    event LogSellCattle(address indexed owner, uint256 indexed basePrice, uint256 timestamp);
    event LogBuyCattle(address indexed buyer, uint256 indexed price, uint256 timestamp);

    mapping(address => mapping(uint256 => bool)) isCattleVerifiedByGov public;

    modifier onlyCattleOwner(uint256 _cattleId) {
        address cattleOwner = cattleContract.ownerOf(_cattleId);
        require(msg.sender == cattleOwner, "NON_OWNER_CANNOT_SELL_CATTLE");
        _;
    }

    modifier onlyGovernment() {
        require(msg.sender == GOV_ADDRESS, "CALLER_IS_NOT_GOVERNMENT");
        _;
    }

    /**
    * @dev Constructor function
    * @param _cattleContract The cattle contract address
    */
    constructor(address _cattleContract, address _auctionContract, address _governmentContract) public {
        require(_cattleContract != address(0), "CATTLE_CONTRACT_ADDRESS_IS_ZERO_ADDRESS");
        require(_auctionContract != address(0), "AUCTION_CONTRACT_ADDRESS_IS_ZERO_ADDRESS");
        cattleContract = Cattle(_cattleContract);
        auctionContract = Auction(_auctionContract);
        governmentContract = Government(_governmentContract);
        GOV_ADDRESS = _governmentContract;
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
        require(cattleContract._exists(cattleId), "CATTLE_ID_DO_NOT_EXISTS");
        require(isCattleVerifiedByGov, "CATTLE_IS_NOT_VERIFIED_YET_BY_GOVERNMENT");
        //Call auction contract to set auction for above cattleId
        auctionContract.auctionCattle(msg.sender, cattleId, basePrice, auctionStartTimestamp, auctionEndTimestamp);
        emit LogSellCattle(msg.sender, basePrice, block.timestamp);
    }

    /**
    * @dev Function that sets the bidAmount for the Cattle that is being put on sale
    * @param cattleId uint256 The cattle ID that is being put up for sale
    */
    function buyCattle(address buyer, uint256 cattleId, uint256 bidAmount) public {
        //Call auction contract's bidAmountForCattle function
        //buyer's address will be passed by Auction contract
        emit LogBuyCattle(buyer, bidAmount, block.timestamp);
    }

    /**
    * @dev Function that gets the cattle details
    * @param cattleId uint256 The cattle ID whose details has to be fetched
    */
    function getCattleDetails(uint cattleId) public view returns (string memory cattleDetails){
        return cattleContract.tokenURI(cattleId);
    }
}
