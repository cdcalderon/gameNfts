//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./DaiToken.sol";
import "./Weapons.sol";

contract NFTEquipment is Ownable, ERC1155Holder {
    struct UserInfo {
        uint256 stakedAmount; // current amount of tokens staked
        uint256 lastUpdateAt; // timestamp for last details update (when pointsDebt calculated)
        uint256 pointsDebt; // total wei points collected before latest deposit.
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
    NFTInfo[] public nftInfo;

    constructor(
        uint256 _emissionRate,
        DaiToken _token,
        Weapons weapons
    ) {
        emissionRate = _emissionRate;
        token = _token;
        weapons = _weapons;
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

    function stakeTokens(uint256 _amount) external {
        token.transferFrom(msg.sender, address(this), _amount);

        UserInfo storage user = userInfo[msg.sender];

        // already deposited before
        if (user.stakedAmount != 0) {
            user.pointsDebt = pointsBalance(msg.sender);
        }
        user.stakedAmount += _amount;
        user.lastUpdateAt = block.timestamp;
    }

    // claim nfts if points threshold reached
    function claimNFTs(uint256[] calldata _nftIndexes, uint256[] calldata _quantities) external {
        require(_nftIndexes.length == _quantities.length, "Incorrect array length");

        for (uint64 i = 0; i < _nftIndexes.length; i++) {
            NFTInfo storage nft = nftInfo[_nftIndexes[i]];

            uint256 cost = nft.price * _quantities[i];
            uint256 points = pointsBalance(msg.sender);
            require(nft.remaining > _quantities[i], "Not enough NFT weapons in equipment");
            require(points >= cost, "Insufficient Points");

            UserInfo memory user = userInfo[msg.sender];
            // deduct user points
            user.pointsDebt = points - cost;
            user.lastUpdateAt = block.timestamp;
            userInfo[msg.sender] = user;
            nft.remaining -= _quantities[i];
        }

        weapons.safeBatchTransferFrom(address(this), msg.sender, _nftIndexes, _quantities, "");
    }

    function stakeTokens(uint256 _amount) external {
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function unstakeTokens() public {
        UserInfo memory user = userInfo[msg.sender];
        require(user.stakedAmount > 0, "staking balance cannot be 0");

        token.transfer(msg.sender, user.stakedAmount);

        // update userInfo
        user.pointsDebt = pointsBalance(msg.sender);
        user.stakedAmount = 0;
        user.lastUpdateAt = block.timestamp;
        userInfo[msg.sender] = user;
    }

    function pointsBalance(address userAddress) public view returns (uint256) {
        UserInfo storage user = userInfo[userAddress];
        return (user.pointsDebt + (_unDebitedPoints(user)));
    }

    function nftCount() public view returns (uint256) {
        return nftInfo.length;
    }

    function _unDebitedPoints(UserInfo memory user) internal view returns (uint256) {
        return (block.timestamp - user.lastUpdateAt) * (emissionRate * user.stakedAmount);
    }
}
