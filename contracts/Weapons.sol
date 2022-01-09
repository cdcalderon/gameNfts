// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Crops is
    ERC1155("https://ipfs.io/ipfs/bafybeicvfevtm5hi33guhypkfw4gv2upabhsltcfysvydbsbcgmruj2w5q")
{
    uint256 public constant HAMMER = 0;
    uint256 public constant PISTOL = 1;

    constructor() {
        _mint(msg.sender, HAMMER, 100, "");
        _mint(msg.sender, PISTOL, 2000, "");
    }
}
