//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract NFTEquipment is Ownable, ERC1155Holder {
    struct UserInfo {
        uint256 stakedAmount;
        uint256 lastUpdateAt;
        uint256 pointsDebt;
    }

    struct NFTInfo {
        uint256 id;
        uint256 remaining;
        uint256 price;
    }

    constructor(uint256 _emissionRate, DaiToken _token) {
        emissionRate = _emissionRate;
        token = _token;
    }
}
