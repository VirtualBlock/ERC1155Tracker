# ERC1155Tracker

A composible ERC1155 compatible NFT contract in which ownership is mapped to tokens instead of contracts.

This contract primitive alows you to attach tokens to other tokens. In this case we attach ERC1155 Tokens to ERC721 Tokens.

It's primary use is to attach assets to a persona, SBT, or a legal entity, but it can also be used to bundle any other kind of NFTs and transfer infinite tokens with a single transaction.


# Usage

The ERC1155Tracker co-exists with another ERC721 contract and tracks its owners. 

* New tokens are assigned to existing ERC721 tokens and track their owner

* Owner tracking is done on read, so no manual updates are necessary 

* Multiple Tracker contracts can follow the same ERC721 contract and attach themselves to the main ERC721 NFT


# Tests

This repo inherits the ERC1155 unit tests (hardhat-truffle) from the official OpenZeppelin contract tests. To run the tests:

- install the dependencies with `yarn` or `npm install`
- Run `npx hardhat test tests/ERC1155.test.js`
