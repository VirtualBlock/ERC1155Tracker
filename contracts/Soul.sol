// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

// import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "./interfaces/ISoul.sol";
import "./libraries/Utils.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @title Soulbound NFT Identity Tokens
 * @dev Version 0.9
 *  - Contract is open for everyone to mint.
 *  - Max of one NFT assigned for each account
 *  - Minted Token's URI is updatable by Token holder
 *  - Assets are non-transferable by owner
 *  - Tokens can be merged (multiple owners)
 *  - Owner can mint tokens for Contracts
 */
contract Soul is 
        ISoul, 
        Ownable, 
        ERC721URIStorage {
    
    //--- Storage
    
    using AddressUpgradeable for address;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(address => uint256) internal _owners;  //Map Multiple Accounts to Tokens (Aliases)

    //--- Functions

    constructor() ERC721("Soulbound Tokens (Identity)", "SBT") { }

    /// ERC165 - Supported Interfaces
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(ISoul).interfaceId
            || interfaceId == type(IERC721).interfaceId 
            || super.supportsInterface(interfaceId);
    }

    //** Token Owner Index **/

    /// Map Account to Existing Token
    function tokenOwnerAdd(address owner, uint256 tokenId) external override onlyOwner {
        _tokenOwnerAdd(owner, tokenId);
    }

    /// Remove Account from Existing Token
    function tokenOwnerRemove(address owner, uint256 tokenId) external override onlyOwner {
        _tokenOwnerRemove(owner, tokenId);
    }

    /// Get Token ID by Address
    function tokenByAddress(address owner) external view override returns (uint256) {
        return _owners[owner];
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return (_owners[owner] != 0) ? 1 : 0;
    }

    /// Map Account to Existing Token (Alias / Secondary Account)
    function _tokenOwnerAdd(address owner, uint256 tokenId) internal {
        require(_exists(tokenId), "nonexistent token");
        require(_owners[owner] == 0, "Account already mapped to token");
        _owners[owner] = tokenId;
        //Faux Transfer Event (Mint)
        emit Transfer(address(0), owner, tokenId);
    }

    /// Map Account to Existing Token (Alias / Secondary Account)
    function _tokenOwnerRemove(address owner, uint256 tokenId) internal {
        require(_exists(tokenId), "nonexistent token");
        require(_owners[owner] == tokenId, "Account is not mapped to this token");
        //Not Main Account
        require(owner != ownerOf(tokenId), "Account is main token's owner. Use burn()");
        //Remove Association
        _owners[owner] = 0;
        //Faux Transfer Event (Burn)
        emit Transfer(owner, address(0), tokenId);
    }

    
    //** Token Actions **/
    
    /// Mint (Create New Token for Someone Else)
    function mintFor(address to, string memory tokenURI) public override onlyOwner returns (uint256) {
        return _mint(to, tokenURI);
    }

    /// Mint (Create New Token for oneself)
    function mint(string memory tokenURI) external override returns (uint256) {
        return _mint(_msgSender(), tokenURI);
    }
	
    /// Burn NFTs
    function burn(uint256 tokenId) external {
        //Validate - Contract Owner 
        require(_msgSender() == owner(), "Only Owner");
        //Burn Token
        _burn(tokenId);
    }

    /// Update Token's Metadata
    function update(uint256 tokenId, string memory uri) external override returns (uint256) {
        //Validate Owner of Token
        require(_isApprovedOrOwner(_msgSender(), tokenId) || _msgSender() == owner(), "caller is not owner or approved");
        _setTokenURI(tokenId, uri);	//This Goes for Specific Metadata Set (IPFS and Such)
        //Emit URI Changed Event
        emit URI(uri, tokenId);
        //Done
        return tokenId;
    }

    /// Create a new Token
    function _mint(address to, string memory uri) internal returns (uint256) {
        //One Per Account
        require(to == address(this) || balanceOf(to) == 0, "Account already has a token");
        //Mint
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(to, newItemId);
        //Set URI
        _setTokenURI(newItemId, uri);	//This Goes for Specific Metadata Set (IPFS and Such)
        //Emit URI Changed Event
        emit URI(uri, newItemId);
        //Done
        return newItemId;
    }
    
    /// Token Transfer Rules
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
        //Non-Transferable (by client)
        require(
            _msgSender() == owner()
            || from == address(0)   //Minting
            , "Sorry, assets are non-transferable"
        );
        
        //Update Address Index        
        if(from != address(0)) _owners[from] = 0;
        if(to != address(0) && to != address(this)) {
            require(_owners[to] == 0, "Receiving address already owns a token");
            _owners[to] = tokenId;
        }
    }

    /// Override transferFrom()
    /// Remove Approval Check 
    /// Transfer Privileges are manged in the _beforeTokenTransfer function
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        //solhint-disable-next-line max-line-length
        // require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }

    /// Transfer Privileges are manged in the _beforeTokenTransfer function
    /// @dev Override the main Transfer privileges function
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view override returns (bool) {
        //Approved or Seconday Owner
        return (
            super._isApprovedOrOwner(spender, tokenId)  // Token Owner or Approved 
            || (_owners[spender] == tokenId)    //Or Secondary Owner
        );
    }

}
