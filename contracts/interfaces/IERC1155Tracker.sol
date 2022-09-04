// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

/**
 * Based on OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 * with Added tracker functionality
 */
interface IERC1155Tracker is IERC1155Upgradeable {

    /// Get Target Contract
    function getTargetContract() external view returns (address);

    /// Get a Token ID Based on account address (Throws)
    function getExtTokenId(address account) external view returns(uint256);
    
    /// Unique Members Addresses
    function uniqueMembers(uint256 id) external view returns (uint256[] memory);
    
    /// Unique Members Count (w/Token)
    function uniqueMembersCount(uint256 id) external view returns (uint256);
    
    /// Check balance by SBT Token ID
    function balanceOfToken(uint256 originTokenId, uint256 id) external view returns (uint256);

    /// Single Token Transfer
    event TransferByToken(address indexed operator, uint256 indexed fromOwnerToken, uint256 indexed toOwnerToken, uint256 id, uint256 value);

    /// Batch Token Transfer
    event TransferBatchByToken(
        address indexed operator,
        uint256 indexed fromOwnerToken, 
        uint256 indexed toOwnerToken,
        uint256[] ids,
        uint256[] values
    );


}