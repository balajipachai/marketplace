pragma solidity 0.5.2;

import "./Farmer.sol";
import "./openZeppelin/utils/Address.sol";

contract Government {
    using Address for address;
    Farmer public farmerContract;

    /**
    * TODO Add Documentation
    */
    function setFarmer(address _farmerContractAddress) public {
        require(_farmerContractAddress.isContract(), "ADDRESS_NOT_A_CONTRACT_ADDRESS");
        farmerContract = Farmer(_farmerContractAddress);
    }

    /**
    * TODO Add Documentation
    */
    function verifyDairyCompany(string memory companyDetails) public pure returns (bool) {
        return true;
    }

    /**
    * TODO Add Documentation
    */
    function verifyCattle(uint256 _cattleId) public pure returns (bool) {
        return true;
    }
}
