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
        _mint(msg.sender, SHIELD, 3000, "");
        _mint(msg.sender, BOW, 5000, "");
        _mint(msg.sender, GRENADE, 10000, "");
        _mint(msg.sender, AKM, 20000, "");
    }

    function addNFTs(
        uint256[] calldata _ids,
        uint256[] calldata _totals, // amount of NFTs deposited to farm (need to approve before)
        uint256[] calldata _prices
    ) external onlyOwner {
        require(
            _ids.length == _totals.length || _totals.length == _prices.length,
            "Incorrect length"
        );
    }
}
