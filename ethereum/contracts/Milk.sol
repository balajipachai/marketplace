/**
* Contract registers the milk against ERC721 Token.
* As ERC721 are NFT's, thus, they are the ideal choice for representing _Milk.
*/
pragma solidity 0.5.2;
import "./openZeppelin/token/ERC721/ERC721Burnable.sol";
import "./openZeppelin/token/ERC721/ERC721Enumerable.sol";
import "./openZeppelin/token/ERC721/ERC721MetadataMintable.sol";


contract Milk is ERC721Burnable, ERC721Enumerable, ERC721MetadataMintable {
    using Address for address;
    /*
    * Constructor function that sets up the name and symbol for Milk ERC721 Tokens
    */
    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
    }

    modifier onlyMilkOwner(uint256 _milkId) {
        require(msg.sender == super.ownerOf(_milkId), "MILK_OWNER_DO_NOT_MATCH");
        _;
    }

    /*
    * @dev Function that maps milk with ERC721 Token.
    * @param to address to whom the milk belongs
    * @param milkDetails string hash of milk details
    */
    function milkRegistration(address to, string memory milkDetails) public onlyMinter returns (bool) {
        uint256 milkId = totalSupply();
        return super.mintWithTokenURI(to, milkId, milkDetails);
    }

    /**
    * @dev Function that gets the number of milks a owner owns
    * @param owner address Address of the owner
    */
    function getNoOfRegisteredMilk(address owner) public view returns (uint256) {
        return super.balanceOf(owner);
    }

    /**
    * @dev Function that returns the owner of a specific milk
    * @param milkId uint256 The milk ID
    */
    function ownerOfMilk(uint256 milkId) public view returns (address) {
        return super.ownerOf(milkId);
    }

    /**
    * @dev Function that approves the Auction contract to transfer milk on behalf of the owner
    * @param to address To is the Auction contract address
    * @param milkId uint256 The milk ID
    */
    function approveAuctionContract(address to, uint256 milkId) onlyMilkOwner(milkId) public {
        require(to.isContract(), "TO_ADDRESS_IS_EOA");
        super.approve(to, milkId);
    }

    /**
    * @dev Function that transfers milk ownership
    * @param oldOwner Milk's old owner
    * @param newOwner Milk's new owner
    * @param milkId uint256 The milk ID
    */
    function transferMilkOwnership(address oldOwner, address newOwner, uint256 milkId) public {
        super.safeTransferFrom(oldOwner, newOwner, milkId);
    }

    /**
    * @dev Function that removes milk registration
    * @param milkId uint256 The milk ID
    */
    function removeMilkRegistration(uint256 milkId) public {
        super.burn(milkId);
    }

    /**
    * Function that checks whether the milkId exist or not
    */
    function exists(uint256 _milkId) external view returns (bool){
        return super._exists(_milkId);
    }
}
