// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721Tracker is IERC721MetadataUpgradeable {

    /// Get Target Contract
    function getTargetContract() external view returns (address);

    /// Unique Members Addresses
    function uniqueMembers(uint256 id) external view returns (uint256[] memory);
    
    /// Unique Members Count (w/Token)
    function uniqueMembersCount(uint256 id) external view returns (uint256);
    
    /// Single Token Transfer
    // event TransferByToken(address indexed operator, uint256 indexed fromOwnerToken, uint256 indexed toOwnerToken, uint256 id, uint256 value);    //ERC1155
    event TransferByToken(uint256 indexed fromOwnerToken, uint256 indexed toOwnerToken, uint256 indexed id);

}
