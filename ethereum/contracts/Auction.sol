pragma solidity 0.5.0;
import "./Cattle.sol";

contract Auction {

    using Address for address;
    Cattle public cattleContract;
    constructor(address _cattleContract) public {
        require(_cattleContract.isContract(), "CATTLE_CONTRACT_ADDRESS_IS_EOA");
        cattleContract = Cattle(_cattleContract);
    }

    struct AuctionedCattle {
        uint256 cattleId;
        uint256 basePrice;
        uint256 auctionStartTimestamp;
        uint256 auctionEndTimestamp;
    }

    address[] sellers;

    mapping(address => bool) sellerExists public;
    mapping(address => (mapping(uint256 => uint256))) bidderAndBiddingAmount public;
    mapping(uint256 => uint256[]) bidAmountForCattleId public;
    mapping(address => AuctionedCattle[]) auctionedCattleDetails public;
    mapping(address => AuctionedMilk[]) auctionedMilkDetails public;

    /**
    * @dev Function that puts the cattle for auction
    * @param _owner The cattle owner
    * @param _cattleId uint256 The cattle ID
    * @param _basePrice Starting price from which the bidding starts
    * @param _auctionStartTimestamp Timestamp when to start the auction
    * @param _auctionEndTimestamp Timestamp when to end the auction
    */
    function auctionCattle(
        address _owner,
        uint256 _cattleId,
        uint256 _basePrice,
        uint256 _auctionStartTimestamp,
        uint256 _auctionEndTimestamp
    ) public {
        if (sellerExists[owner] == true) {
            _saveAuctionedCattleDetails(_owner, _cattleId, _basePrice, _auctionStartTimestamp, _auctionEndTimestamp);
        } else {
            sellers.push(owner);
            sellerExists[owner] = true;
            _saveAuctionedCattleDetails(_owner, _cattleId, _basePrice, _auctionStartTimestamp, _auctionEndTimestamp);
        }
    }

    /**
    * @dev Function that gets all auctioned cattle details
    */
    function getAuctionedCattleDetails() public view returns {
        //Traverse and get all the auctioned cattle details that will be displayed onto the UI
    }

    /**
    * @dev Function that stores the bidding for cattle
    * @param _buyer address of the cattle buyer
    * @param _cattleId uint256 The cattle ID
    * @param _bidAmount uint256 The bid amount
    */
    function bidForCattle(address _buyer, uint256 _cattleId, uint256 _bidAmount) public {
        address owner = cattleContract.ownerOfCattle(_cattleId);
        uint256 auctionEndTimestamp = _getAuctionedCattleAuctionEndTimestamp(owner, _cattleId);
        //Get details of specific _cattleId
        require(block.timestamp > auctionEndTimestamp, "BIDDING_PERIOD_EXPIRED");
        //Save bid details
        bidderAndBiddingAmount[buyer][_cattleId] = _bidAmount;
        //Pull in the money into the Auction contract from _buyer
        bidAmountForCattleId[_cattleId].push(_bidAmount);
        //check whether auctionTimestamp for the cattleId is expired
        if (block.timestamp > auctionEndTimestamp) {
            //it implies auction period has ended, search for the maximum bidAmount and transfer cattleOwnership
            uint256 maximumBidAmount = _getMaximumBidAmount(_cattleId);
            //transfer maximumBidAmount to owner from Auction Contract
            //transfer cattle ownership to buyer
        }
        //check whether bidding amount is greater than the previous bid
        // if above 2 checks are yes, then, transfer ownership of the cattle to the buyer
        // and transfer the amount to the previous owner
    }

    function _saveAuctionedCattleDetails(
        address _owner,
        uint256 _cattleId,
        uint256 _basePrice,
        uint256 _auctionStartTimestamp,
        uint256 _auctionEndTimestamp
    ) internal {
        auctionedCattleDetails[owner].AuctionedCattle.push({
        cattleId: _cattleId,
        basePrice: _basePrice,
        auctionStartTimestamp: _auctionStartTimestamp,
        auctionEndTimestamp: _auctionEndTimestamp
        });
    }

    function _getAuctionedCattleAuctionEndTimestamp(address owner, uint256 cattleId) internal returns (uint256) {
        AuctionedCattle memory _cattleDetails;
        for(uint256 i = 0; i < auctionedCattleDetails[owner].AuctionedCattle.length; i++) {
            if (cattleId == auctionedCattleDetails[owner].AuctionedCattle[i].cattleId) {
                _cattleDetails = auctionedCattleDetails[owner].AuctionedCattle[i];
                break;
            }
        }
        return _cattleDetails.auctionEndTimestamp;
    }

    function _getMaximumBidAmount(uint256 cattleId) internal returns (uint256) {
        uint256 max = bidAmountForCattleId[cattleId][0];
        for(uin256 i = 1; i < bidAmountForCattleId[cattleId].length; i++) {
            if (bidAmountForCattleId[cattleId][i] > max) {
                max = bidAmountForCattleId[cattleId][i];
            }
        }
        return max;
    }

}
