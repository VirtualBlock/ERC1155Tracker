//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "./interfaces/IConfig.sol";
// import "./interfaces/ICommonYJ.sol";
// import "./interfaces/IHub.sol";
// import "./interfaces/IJurisdictionUp.sol";
// import "./interfaces/ICase.sol";
import "./interfaces/IAvatar.sol";
import "./libraries/DataTypes.sol";
import "./abstract/CommonYJ.sol";


/** [DEV] MiniHub for Testing Purposes
 * YJ Hub Contract
 * - Hold Known Contract Addresses (Avatar, History)
 * - Contract Factory (Jurisdictions & Cases)
 * - Remember Products (Jurisdictions & Cases)
 */
contract Hub is Ownable {
    //---Storage
    address public beaconCase;
    address public beaconJurisdiction;  //TBD

    //Contract Associations (avatar, history)
    mapping(string => address) internal _assoc;
    
    // using Counters for Counters.Counter;
    // Counters.Counter internal _tokenIds; //Track Last Token ID
    // Counters.Counter internal _caseIds;  //Track Last Case ID

    // Arbitrary contract designation signature
    string public constant role = "YJHub";
    string public constant symbol = "YJHub";

    //--- Storage
    mapping(address => bool) internal _jurisdictions; // Mapping for Active Jurisdictions   //[TBD]
    mapping(address => address) internal _cases;      // Mapping for Case Contracts  [C] => [J]


    //--- Events
    //TODO: Owner 
    //TODO: Config changed

    //--- Functions

    constructor(){ }

    //-- Assoc

    ////Get Contract Association
    function getAssoc(string memory key) public view returns(address) {
        //Validate
        require(_assoc[key] != address(0) , string(abi.encodePacked("Faild to Get Assoc: ", key)));
        return _assoc[key];
    }

    //Set Association
    function setAssoc(string memory key, address contract_) external onlyOwner {
        _setAssoc(key, contract_);
    }

    //Set Association
    function _setAssoc(string memory key, address contract_) internal {
        _assoc[key] = contract_;
    }


    //--- Reputation

    /// Add Reputation (Positive or Negative)       /// Opinion Updated
    function repAdd(address contractAddr, uint256 tokenId, string calldata domain, bool rating, uint8 amount) public {

        //TODO: Validate - Known Jurisdiction
        // require(_jurisdictions[_msgSender()], "NOT A VALID JURISDICTION");

        // console.log("Hub: Add Reputation to Contract:", contractAddr, tokenId, amount);
        // console.log("Hub: Add Reputation in Domain:", domain);
        address avatarContract = getAssoc("avatar");
        //Update Avatar's Reputation    //TODO: Just Check if Contract Implements IRating
        if(avatarContract != address(0) && avatarContract == contractAddr){
            _repAddAvatar(tokenId, domain, rating, amount);
        }
    }

    /// Add Repuation to Avatar
    function _repAddAvatar(uint256 tokenId, string calldata domain, bool rating, uint8 amount) internal {
        address avatarContract = getAssoc("avatar");
        // require(avatarContract != address(0), "AVATAR_CONTRACT_UNKNOWN");
        // repAdd(avatarContract, tokenId, domain, rating, amount);
        IAvatar(avatarContract).repAdd(tokenId, domain, rating, amount);
    }

}