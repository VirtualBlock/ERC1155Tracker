// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../abstract/ERC1155TrackerUpgradable.sol";

/**
 * @title ERC1155Mock
 * This is mock contract that implements ERC1155Tracker 
 */
contract ERC1155Mock is ERC1155TrackerUpgradable {

    constructor(address targetContract) {
        __setTargetContract(targetContract);
    }

    function mint(
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public {
        _mint(to, id, value, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public {
        _mintBatch(to, ids, values, data);
    }

    function burn(
        address owner,
        uint256 id,
        uint256 value
    ) public {
        _burn(owner, id, value);
    }

    function burnBatch(
        address owner,
        uint256[] memory ids,
        uint256[] memory values
    ) public {
        _burnBatch(owner, ids, values);
    }
}
