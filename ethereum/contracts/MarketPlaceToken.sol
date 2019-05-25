pragma solidity 0.5.2;

import "./openZeppelin/token/ERC20/ERC20.sol";
import "./openZeppelin/token/ERC20/ERC20Detailed.sol";

contract MarketPlaceToken is ERC20, ERC20Detailed{
    constructor (
        string memory name,
        string memory symbol,
        uint8 decimals,
        address to,
        uint256 totalSupply
    ) ERC20Detailed(name, symbol, decimals) public {
        super._mint(to, totalSupply);
    }
}
