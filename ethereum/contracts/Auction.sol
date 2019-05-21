pragma solidity 0.5.0;

contract Auction {
    mapping(address => bool) sellerExists public;
    address[] sellers;
    mapping(address => AuctionedCattle[]) auctionedCattleDetails public;
    mapping(address => AuctionedMilk[]) auctionedMilkDetails public;

    struct AuctionedCattle {
        uint256 cattleId;
        uint256 basePrice;
        uint256 auctionStartTimestamp;
        uint256 auctionEndTimestamp;
    }

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
            saveAuctionedCattleDetails(_owner, _cattleId, _basePrice, _auctionStartTimestamp, _auctionEndTimestamp);
        } else {
            sellers.push(owner);
            sellerExists[owner] = true;
            saveAuctionedCattleDetails(_owner, _cattleId, _basePrice, _auctionStartTimestamp, _auctionEndTimestamp);
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
        //Save bid details
        //check whether auctionTimestamp for the cattleId is expired
        //check whether bidding amount is greater than the previous bid
        // if above 2 checks are yes, then, transfer ownership of the cattle to the buyer
        // and transfer the amount to the previous owner
    }

    function saveAuctionedCattleDetails(
        address _owner,
        uint256 _cattleId,
        uint256 _basePrice,
        uint256 _auctionStartTimestamp,
        uint256 _auctionEndTimestamp
    ) internal {
        auctionedCattleDetails[owner].AuctionedCattle.push({
        cattleId:
        basePrice;
        auctionStartTimestamp;
        auctionEndTimestamp;
        });
    }

}
