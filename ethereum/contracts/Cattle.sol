/**
* Contract registers the cattle against ERC721 Token.
* As ERC721 are NFT's, thus, they are the ideal choice for representing Cattle.
*/
pragma solidity 0.5.2;
import "./openZeppelin/token/ERC721/ERC721Burnable.sol";
import "./openZeppelin/token/ERC721/ERC721Enumerable.sol";
import "./openZeppelin/token/ERC721/ERC721MetadataMintable.sol";


contract Cattle is ERC721Burnable, ERC721Enumerable, ERC721MetadataMintable {
    using Address for address;
    /*
    * Constructor function that sets up the name and symbol for Cattle ERC721 Tokens
    */
    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
    }

    modifier onlyCattleOwner(uint256 _cattleId) {
        require(msg.sender == super.ownerOf(_cattleId), "CATTLE_OWNER_DO_NOT_MATCH");
        _;
    }

    /*
    * @dev Function that maps cattle with ERC721 Token.
    * @param to address to whom the cattle belongs
    * @param cattleDetails string hash of cattle details
    */
    function cattleRegistration(address to, string memory cattleDetails) public onlyMinter returns (bool) {
        uint256 cattleId = totalSupply();
        return super.mintWithTokenURI(to, cattleId, cattleDetails);
    }

    /**
    * @dev Function that gets the number of cattles a owner owns
    * @param owner address Address of the owner
    */
    function getNoOfCattle(address owner) public view returns (uint256) {
        return super.balanceOf(owner);
    }

    /**
    * @dev Function that returns the owner of a specific cattle
    * @param cattleId uint256 The cattle ID
    */
    function ownerOfCattle(uint256 cattleId) public view returns (address) {
        return super.ownerOf(cattleId);
    }

    /**
    * @dev Function that approves the Auction contract to transfer cattle on behalf of the owner
    * @param to address To is the Auction contract address
    * @param cattleId uint256 The cattle ID
    */
    function approveAuctionContract(address to, uint256 cattleId) onlyCattleOwner(cattleId) public {
        require(to.isContract(), "TO_ADDRESS_IS_EOA");
        super.approve(to, cattleId);
    }

    /**
    * @dev Function that transfers cattle ownership
    * @param oldOwner Cattle's old owner
    * @param newOwner Cattle's new owner
    * @param cattleId uint256 The cattle ID
    */
    function transferCattleOwnership(address oldOwner, address newOwner, uint256 cattleId) public {
        super.safeTransferFrom(oldOwner, newOwner, cattleId);
    }

    /**
    * @dev Function that removes cattle registration
    * @param cattleId uint256 The cattle ID
    */
    function removeCattleRegistration(uint256 cattleId) public {
        super.burn(cattleId);
    }

    /**
    * Function that checks whether the catlleId exist or not
    */
    function exists(uint256 _cattleId) external view returns (bool){
        return super._exists(_cattleId);
    }
}
