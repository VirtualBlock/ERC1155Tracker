// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/**
 * @title Soulbound Token Interface
 * @dev Additions to IERC721 
 */
interface ISoul {

    //--- Functions

    /// Get Token ID by Address
    function tokenByAddress(address owner) external view returns (uint256);

    /// Mint (Create New Avatar for oneself)
    function mint(string memory tokenURI) external returns (uint256);

    /// Mint (Create New Token for Someone Else)
    function mintFor(address to, string memory tokenURI) external returns (uint256);

    /// Update Token's Metadata
    function update(uint256 tokenId, string memory uri) external returns (uint256);

    /// Map Account to Existing Token
    function tokenOwnerAdd(address owner, uint256 tokenId) external;

    /// Remove Account from Existing Token
    function tokenOwnerRemove(address owner, uint256 tokenId) external;

    //--- Events
    
	/// URI Change Event
    event URI(string value, uint256 indexed id);    //Copied from ERC1155

}
