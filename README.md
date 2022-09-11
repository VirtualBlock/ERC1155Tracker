# ERC1155Tracker (& ERC721Tracker)

Tracker contracts are is an ERC-1155/ERC-721 compatible NFT contracts in which ownership is mapped to an SBT tokens instead of wallet addresses.

This allows you to attach tokens to other ERC721 Tokens.

It's primary use is to attach assets to a persona, SBT, or a legal entity, but it can also be used to bundle any other kind of NFTs and transfer ownership over a basket of tokens using a single low-gas transaction.


# Usage

The ERC1155Tracker must co-exists with another Soul (ERC-721 compatible) contract and tracks its owners. 

* New tokens are assigned to existing ERC721 tokens and track their owner

* Owner tracking is done on read, so no manual updates are necessary 

* Multiple Tracker contracts can follow the same ERC721 contract and attach themselves to the main ERC721 NFT


# Tests

This repo inherits the ERC1155 unit tests (hardhat-truffle) from the official OpenZeppelin contract tests. To run the tests:

- install the dependencies with `yarn` or `npm install`
- Run `npx hardhat test tests/ERC1155.test.js`
