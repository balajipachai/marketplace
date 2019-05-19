/**
* Contract registers the cattle against ERC721 Token.
* As ERC721 are NFT's, thus, they are the ideal choice for representing Cattle.
*/
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
        require(msg.sender == super.ownerOf(cattleId), "CATTLE_OWNER_DO_NOT_MATCH");
        _;
    }
    /*
    * @dev Function that maps cattle with ERC721 Token.
    */
    function mapCattleWithERC721(address to, string memory cattleDetails) public onlyMinter returns (bool) {
        uint256 cattleId = totalSupply();
        return super.mintWithTokenURI(to, cattleId, cattleDetails);
    }

    /**
    * TODO @balaji Add comments before committing the code
    */
    function getNoOfCattle(address owner) public view returns (uint256) {
        return super.balanceOf();
    }

    /**
    * TODO @balaji Add comments before committing the code
    */
    function ownerOfCattle(uint256 cattleId) public view returns (address) {
        return super.ownerOf(cattleId);
    }

    /**
    * TODO @balaji Add comments before committing the code
    */
    function approveAuctionContract(address to, uint256 cattleId) onlyCattleOwner(cattleId) public {
        require(to.isContract(), "TO_ADDRESS_IS_EOA");
        super.approve(to, cattleId);
    }

    /**
    * TODO @balaji Add comments before committing the code
    */
    function transferCattleOwnership(address oldOwner, address newOwner, uint256 cattleId) public {
        super.safeTransferFrom(oldOwner, newOwner, cattleId);
    }

    /**
    * TODO @balaji Add comments before committing the code
    */
    function removeCattleMappingWithERC721(uint256 cattleId) public {
        super.burn(cattleId);
    }
}
