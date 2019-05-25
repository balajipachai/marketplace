pragma solidity 0.5.2;
import "./Cattle.sol";
import "./MarketPlaceToken.sol";
import "./Milk.sol";

contract Auction {
    using SafeMath for uint256;
    using Address for address;

    Cattle public cattleContract;
    MarketPlaceToken public marketPlaceContract;
    Milk public milkContract;

    constructor(address _cattleContract, address _marketPlaceContract, address _milkContract) public {
        require(_cattleContract.isContract(), "CATTLE_CONTRACT_ADDRESS_IS_EOA");
        require(_marketPlaceContract.isContract(), "MARKETPLACE_CONTRACT_ADDRESS_IS_EOA");
        require(_milkContract.isContract(), "MILK_CONTRACT_ADDRESS_IS_EOA");
        cattleContract = Cattle(_cattleContract);
        marketPlaceContract = MarketPlaceToken(_marketPlaceContract);
        milkContract = Milk(_milkContract);
    }

    struct AuctionedCattle {
        uint256 cattleId;
        uint256 basePrice;
        uint256 auctionStartTimestamp;
        uint256 auctionEndTimestamp;
        bool isSold;
    }

    address[] public cattleSellers;
    address[] public cattleBuyers;

    mapping(address => bool) public cattleSellerExists;
    mapping(address => mapping(uint256 => uint256)) public cattleBidderAndBiddingAmount;
    mapping(uint256 => uint256[]) public bidAmountForCattleId;
    mapping(address => uint256) public bidAmountAtIndexForCattle;
    mapping(address => AuctionedCattle[]) public auctionedCattleDetails;

    struct AuctionedMilk {
        uint256 milkId;
        uint256 basePrice;
        uint256 auctionStartTimestamp;
        uint256 auctionEndTimestamp;
        bool isSold;
    }

    address[] public milkSellers;
    address[] public milkBuyers;

    mapping(address => bool) public milkSellerExists;
    mapping(address => mapping(uint256 => uint256)) public milkBidderAndBiddingAmount;
    mapping(uint256 => uint256[]) public bidAmountForMilkId;
    mapping(address => uint256) public bidAmountAtIndexForMilk;
    mapping(address => AuctionedMilk[]) public auctionedMilkDetails;

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
        if (cattleSellerExists[_owner] == true) {
            _saveAuctionedCattleDetails(_owner, _cattleId, _basePrice, _auctionStartTimestamp, _auctionEndTimestamp);
        } else {
            cattleSellers.push(_owner);
            cattleSellerExists[_owner] = true;
            _saveAuctionedCattleDetails(_owner, _cattleId, _basePrice, _auctionStartTimestamp, _auctionEndTimestamp);
        }
    }

    function auctionMilk(
        address _owner,
        uint256 _milkId,
        uint256 _basePrice,
        uint256 _auctionStartTimestamp,
        uint256 _auctionEndTimestamp
    ) public {
        if (milkSellerExists[_owner] == true) {
            _saveAuctionedMilkDetails(_owner, _milkId, _basePrice, _auctionStartTimestamp, _auctionEndTimestamp);
        } else {
            milkSellers.push(_owner);
            milkSellerExists[_owner] = true;
            _saveAuctionedMilkDetails(_owner, _milkId, _basePrice, _auctionStartTimestamp, _auctionEndTimestamp);
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
        require(block.timestamp > auctionEndTimestamp, "BIDDING_PERIOD_EXPIRED_FOR_CATTLE");

        //Pull in the money into the Auction contract from _buyer
        //Before pulling in check whether the buyer has already made a bid
        //In that case transfer the previous bid amount back to the buyer
        //and pull in the new bid amount into the Auction contract
        if (cattleBidderAndBiddingAmount[_buyer][_cattleId] > 0) {
            //Transfer previous bid to buyer
            _transferAmount(_buyer, cattleBidderAndBiddingAmount[_buyer][_cattleId]);
        }

        // Pull in _bidAmount into the Auction contract
        _transferAmountOnBehalfOf(_buyer, address(this), _bidAmount);

        //Save bid details
        cattleBidderAndBiddingAmount[_buyer][_cattleId] = _bidAmount;
        if (!(bidAmountForCattleId[_cattleId][bidAmountAtIndexForCattle[_buyer]] > 0)) {
            cattleBuyers.push(_buyer);
            bidAmountForCattleId[_cattleId].push(_bidAmount);
            bidAmountAtIndexForCattle[_buyer] = bidAmountForCattleId[_cattleId].length.sub(1);
        }
    }

    function bidForMilk(address _buyer, uint256 _milkId, uint256 _bidAmount) public {
        address owner = milkContract.ownerOfMilk(_milkId);
        uint256 auctionEndTimestamp = _getAuctionedMilkAuctionEndTimestamp(owner, _milkId);
        require(block.timestamp > auctionEndTimestamp, "BIDDING_PERIOD_EXPIRED_FOR_MILK");
        if (milkBidderAndBiddingAmount[_buyer][_milkId] > 0) {
            //Transfer previous bid to buyer
            _transferAmount(_buyer, milkBidderAndBiddingAmount[_buyer][_milkId]);
        }
        // Pull in _bidAmount into the Auction contract
        _transferAmountOnBehalfOf(_buyer, address(this), _bidAmount);

        //Save bid details
        milkBidderAndBiddingAmount[_buyer][_milkId] = _bidAmount;
        if (!(bidAmountForMilkId[_milkId][bidAmountAtIndexForMilk[_buyer]] > 0)) {
            milkBuyers.push(_buyer);
            bidAmountForMilkId[_milkId].push(_bidAmount);
            bidAmountAtIndexForMilk[_buyer] = bidAmountForMilkId[_milkId].length.sub(1);
        }
    }

    /*TODO Add documentation*/
    function sellCattleToHighestBidder(uint256 _cattleId) public {
        address owner = cattleContract.ownerOfCattle(_cattleId);
        uint256 auctionEndTimestamp = _getAuctionedCattleAuctionEndTimestamp(owner, _cattleId);
        require(block.timestamp < auctionEndTimestamp, "BIDDING_PERIOD_NOT_YET_EXPIRED_FOR_CATTLE");
        //check whether auctionTimestamp for the cattleId is expired
        if (block.timestamp > auctionEndTimestamp) {
            //it implies auction period has ended, search for the maximum bidAmount and transfer cattleOwnership
            uint256 maximumBidAmount = _getMaximumBidAmountForCattle(_cattleId);
            address cattleBuyer = _getBuyerForCattle(_cattleId, maximumBidAmount);
            //transfer maximumBidAmount to owner from Auction Contract
            _transferAmount(owner, maximumBidAmount);
            //transfer cattle ownership to buyer
            cattleContract.transferCattleOwnership(owner, cattleBuyer, _cattleId);
            //set isSold to true
            for (uint8 i = 0; i < auctionedCattleDetails[owner].length; i++) {
                if (auctionedCattleDetails[owner][i].cattleId == _cattleId) {
                    auctionedCattleDetails[owner][i].isSold = true;
                }
            }
        }
    }

    /*TODO Add documentation*/
    function sellMilkToHighestBidder(uint256 _milkId) public {
        address owner = milkContract.ownerOfMilk(_milkId);
        uint256 auctionEndTimestamp = _getAuctionedMilkAuctionEndTimestamp(owner, _milkId);
        require(block.timestamp < auctionEndTimestamp, "BIDDING_PERIOD_NOT_YET_EXPIRED_FOR_MILK");
        if (block.timestamp > auctionEndTimestamp) {
            uint256 maximumBidAmount = _getMaximumBidAmountForMilk(_milkId);
            address milkBuyer = _getBuyerForMilk(_milkId, maximumBidAmount);
            _transferAmount(owner, maximumBidAmount);
            milkContract.transferMilkOwnership(owner, milkBuyer, _milkId);
            for (uint8 i = 0; i < auctionedMilkDetails[owner].length; i++) {
                if (auctionedMilkDetails[owner][i].milkId == _milkId) {
                    auctionedMilkDetails[owner][i].isSold = true;
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

    function getAuctionedMilkDetails(address _owner, uint256 _storedAtIndex) public view returns (uint256[4] memory) {
        uint256[4] memory milkDetails;
        milkDetails[0] = (auctionedMilkDetails[_owner][_storedAtIndex].milkId);
        milkDetails[1] = (auctionedMilkDetails[_owner][_storedAtIndex].basePrice);
        milkDetails[2] = (auctionedMilkDetails[_owner][_storedAtIndex].auctionStartTimestamp);
        milkDetails[3] = (auctionedMilkDetails[_owner][_storedAtIndex].auctionEndTimestamp);
        return milkDetails;
    }

    /*TODO Add documentation*/
    function getNoOfAuctionedCattles(address _owner) public view returns (uint256) {
        return auctionedCattleDetails[_owner].length;
    }

    function getNoOfAuctionedMilks(address _owner) public view returns (uint256) {
        return auctionedMilkDetails[_owner].length;
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

    function _saveAuctionedMilkDetails(
        address _owner,
        uint256 _milkId,
        uint256 _basePrice,
        uint256 _auctionStartTimestamp,
        uint256 _auctionEndTimestamp
    ) internal {
        auctionedMilkDetails[_owner].push(
            AuctionedMilk({
            milkId: _milkId,
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
    function _getAuctionedMilkAuctionEndTimestamp(address owner, uint256 milkId) internal view returns (uint256) {
        AuctionedMilk memory _milkDetails;
        for(uint8 i = 0; i < auctionedMilkDetails[owner].length; i++) {
            if (milkId == auctionedMilkDetails[owner][i].milkId) {
                _milkDetails = auctionedMilkDetails[owner][i];
                break;
            }
        }
        return _milkDetails.auctionEndTimestamp;
    }

    /*TODO Add documentation*/
    function _getMaximumBidAmountForCattle(uint256 cattleId) internal view returns (uint256) {
        uint256 max = bidAmountForCattleId[cattleId][0];
        for(uint8 i = 1; i < bidAmountForCattleId[cattleId].length; i++) {
            if (bidAmountForCattleId[cattleId][i] > max) {
                max = bidAmountForCattleId[cattleId][i];
            }
        }
        return max;
    }

    /*TODO Add documentation*/
    function _getMaximumBidAmountForMilk(uint256 milkId) internal view returns (uint256) {
        uint256 max = bidAmountForMilkId[milkId][0];
        for(uint8 i = 1; i < bidAmountForMilkId[milkId].length; i++) {
            if (bidAmountForMilkId[milkId][i] > max) {
                max = bidAmountForMilkId[milkId][i];
            }
        }
        return max;
    }



    /*TODO Add documentation*/
    function _getBuyerForCattle(uint256 cattleId, uint256 maxBidAmount) internal view returns (address) {
        uint256 index = 0;
        for(uint8 i = 0; i < cattleBuyers.length; i++) {
            if (cattleBidderAndBiddingAmount[cattleBuyers[i]][cattleId] == maxBidAmount) {
                index = i;
                break;
            }
        }
        return cattleBuyers[index];
    }

    /*TODO Add documentation*/
    function _getBuyerForMilk(uint256 milkId, uint256 maxBidAmount) internal view returns (address) {
        uint256 index = 0;
        for(uint8 i = 0; i < milkBuyers.length; i++) {
            if (milkBidderAndBiddingAmount[milkBuyers[i]][milkId] == maxBidAmount) {
                index = i;
                break;
            }
        }
        return milkBuyers[index];
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
