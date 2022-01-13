//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

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
    mapping(address => UserInfo) public userInfo;
    uint256 public emissionRate; // wei points (1 point = 10**18) generated per token per second staked
    DaiToken public token; // mock dai token being staked
    Weapons public weapons; // ERC-1155 NFT weapons contract

    constructor(uint256 _emissionRate, DaiToken _token) {
        emissionRate = _emissionRate;
        token = _token;
    }

    function addNFTs(
        uint256[] calldata _ids,
        uint256[] calldata _totals, // amount of NFTs deposited to farm (need to approve before)
        uint256[] calldata _prices
    ) external onlyOwner {
        require(
            _ids.length == _totals.length || _totals.length == _prices.length,
            "Incorrect totals length"
        ); // TODO improve cost by using error instead
        crops.safeBatchTransferFrom(msg.sender, address(this), _ids, _totals, "");
        for (uint64 i = 0; i < _ids.length; i++) {
            nftInfo.push(NFTInfo({id: _ids[i], remaining: _totals[i], price: _prices[i]}));
        }
    }
}
