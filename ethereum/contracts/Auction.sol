pragma solidity 0.5.2;
import "./Cattle.sol";
import "./MarketPlaceToken.sol";

contract Auction {
    using SafeMath for uint256;
    using Address for address;

    Cattle public cattleContract;
    MarketPlaceToken public marketPlaceContract;

    constructor(address _cattleContract, address _marketPlaceContract) public {
        require(_cattleContract.isContract(), "CATTLE_CONTRACT_ADDRESS_IS_EOA");
        require(_marketPlaceContract.isContract(), "MARKETPLACE_CONTRACT_ADDRESS_IS_EOA");
        cattleContract = Cattle(_cattleContract);
        marketPlaceContract = MarketPlaceToken(_marketPlaceContract);
    }

    struct AuctionedCattle {
        uint256 cattleId;
        uint256 basePrice;
        uint256 auctionStartTimestamp;
        uint256 auctionEndTimestamp;
        bool isSold;
    }

    address[] public sellers;
    address[] public buyers;

    mapping(address => bool) public sellerExists;
    mapping(address => mapping(uint256 => uint256)) public bidderAndBiddingAmount;
    mapping(uint256 => uint256[]) public bidAmountForCattleId;
    mapping(address => uint256) public bidAmountAtIndex;
    mapping(address => AuctionedCattle[]) public auctionedCattleDetails;
//    mapping(address => AuctionedMilk[]) auctionedMilkDetails public;

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
        if (sellerExists[_owner] == true) {
            _saveAuctionedCattleDetails(_owner, _cattleId, _basePrice, _auctionStartTimestamp, _auctionEndTimestamp);
        } else {
            sellers.push(_owner);
            sellerExists[_owner] = true;
            _saveAuctionedCattleDetails(_owner, _cattleId, _basePrice, _auctionStartTimestamp, _auctionEndTimestamp);
        }
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

        //Pull in the money into the Auction contract from _buyer
        //Before pulling in check whether the buyer has already made a bid
        //In that case transfer the previous bid amount back to the buyer
        //and pull in the new bid amount into the Auction contract
        if (bidderAndBiddingAmount[_buyer][_cattleId] > 0) {
            //Transfer previous bid to buyer
            _transferAmount(_buyer, bidderAndBiddingAmount[_buyer][_cattleId]);
        }

        // Pull in _bidAmount into the Auction contract
        _transferAmountOnBehalfOf(_buyer, address(this), _bidAmount);

        //Save bid details
        bidderAndBiddingAmount[_buyer][_cattleId] = _bidAmount;
        if (!(bidAmountForCattleId[_cattleId][bidAmountAtIndex[_buyer]] > 0)) {
            buyers.push(_buyer);
            bidAmountForCattleId[_cattleId].push(_bidAmount);
            bidAmountAtIndex[_buyer] = bidAmountForCattleId[_cattleId].length.sub(1);
        }
    }

    /*TODO Add documentation*/
    function sellCattleToHighestBidder(uint256 _cattleId) public {
        address owner = cattleContract.ownerOfCattle(_cattleId);
        uint256 auctionEndTimestamp = _getAuctionedCattleAuctionEndTimestamp(owner, _cattleId);
        require(block.timestamp < auctionEndTimestamp, "BIDDING_PERIOD_NOT_YET_EXPIRED");
        //check whether auctionTimestamp for the cattleId is expired
        if (block.timestamp > auctionEndTimestamp) {
            //it implies auction period has ended, search for the maximum bidAmount and transfer cattleOwnership
            uint256 maximumBidAmount = _getMaximumBidAmount(_cattleId);
            address cattleBuyer = _getBuyer(_cattleId, maximumBidAmount);
            //transfer maximumBidAmount to owner from Auction Contract
            _transferAmount(owner, maximumBidAmount);
            //transfer cattle ownership to buyer
            cattleContract.transferCattleOwnership(owner, cattleBuyer, _cattleId);
            //set isSold to true
            for (uint256 i = 0; i < auctionedCattleDetails[owner].length; i++) {
                if (auctionedCattleDetails[owner][i].cattleId == _cattleId) {
                    auctionedCattleDetails[owner][i].isSold = true;
                }
            }
        }
    }

    /**
    * @dev Function that gets all auctioned cattle details
    */
    function getAuctionedCattleDetails(address _owner, uint256 _storedAtIndex) public view returns (uint256[4] memory) {
        uint256[4] memory cattleDetails;
        cattleDetails[0] = (auctionedCattleDetails[_owner][_storedAtIndex].cattleId);
        cattleDetails[1] = (auctionedCattleDetails[_owner][_storedAtIndex].basePrice);
        cattleDetails[2] = (auctionedCattleDetails[_owner][_storedAtIndex].auctionStartTimestamp);
        cattleDetails[3] = (auctionedCattleDetails[_owner][_storedAtIndex].auctionEndTimestamp);
        return cattleDetails;
    }

    /*TODO Add documentation*/
    function getNoOfAuctionedCattles(address _owner) public view returns (uint256) {
        return auctionedCattleDetails[_owner].length;
    }

    /*TODO Add documentation*/
    function _saveAuctionedCattleDetails(
        address _owner,
        uint256 _cattleId,
        uint256 _basePrice,
        uint256 _auctionStartTimestamp,
        uint256 _auctionEndTimestamp
    ) internal {
        auctionedCattleDetails[_owner].push(
            AuctionedCattle({
                cattleId: _cattleId,
                basePrice: _basePrice,
                auctionStartTimestamp: _auctionStartTimestamp,
                auctionEndTimestamp: _auctionEndTimestamp,
                isSold: false
            })
        );
    }

    /*TODO Add documentation*/
    function _getAuctionedCattleAuctionEndTimestamp(address owner, uint256 cattleId) internal view returns (uint256) {
        AuctionedCattle memory _cattleDetails;
        for(uint8 i = 0; i < auctionedCattleDetails[owner].length; i++) {
            if (cattleId == auctionedCattleDetails[owner][i].cattleId) {
                _cattleDetails = auctionedCattleDetails[owner][i];
                break;
            }
        }
        return _cattleDetails.auctionEndTimestamp;
    }

    /*TODO Add documentation*/
    function _getMaximumBidAmount(uint256 cattleId) internal view returns (uint256) {
        uint256 max = bidAmountForCattleId[cattleId][0];
        for(uint8 i = 1; i < bidAmountForCattleId[cattleId].length; i++) {
            if (bidAmountForCattleId[cattleId][i] > max) {
                max = bidAmountForCattleId[cattleId][i];
            }
        }
        return max;
    }

    /*TODO Add documentation*/
    function _getBuyer(uint256 cattleId, uint256 maxBidAmount) internal view returns (address) {
        uint256 index = 0;
        for(uint8 i = 0; i < buyers.length; i++) {
            if (bidderAndBiddingAmount[buyers[i]][cattleId] == maxBidAmount) {
                index = i;
                break;
            }
        }
        return buyers[index];
    }

    /*TODO Add documentation*/
    function _transferAmountOnBehalfOf(address _from, address _to, uint256 _amount) internal returns (bool) {
        return marketPlaceContract.transferFrom(_from, _to, _amount);
    }

    /*TODO Add documentation*/
    function _transferAmount(address _to, uint256 _amount) internal returns (bool) {
        return marketPlaceContract.transfer(_to, _amount);
    }

}
