// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";
import "./NewsToken.sol";

contract RewardManager  is AccessControl{
    NewsToken public newsToken; // 声明NewsToken合约的变量
    uint256 public rewardAmount = 100 ether;
    uint256 public penaltyAmount = 200 ether;

    constructor(address _newsTokenAddress) {
        newsToken = NewsToken(_newsTokenAddress); // 初始化NewsToken合约地址
    }

    function setRewardAmount(uint256 _amount) public onlyOwner {
        require(_amount > 0);
        rewardAmount = _amount;
    }

    function setPenaltyAmount(uint256 _amount) public onlyOwner {
         require(_amount > 0);
        penaltyAmount = _amount;
    }

    function processReward(address _dataProvider, bool _isVerified) public onlyAuthorized {
        // 检查新闻验证结果
        if (_isVerified) {
            // 如果新闻验证通过，奖励数据供应商
            require(newsToken.balanceOf(address(this)) >= rewardAmount, "Reward contract does not have enough tokens.");
            newsToken.transfer(_dataProvider, rewardAmount); // 奖励积分
        } else {
            // 如果新闻验证失败，扣除积分
            require(newsToken.allowance(msg.sender, address(this)) >= penaltyAmount, "You don't have enough allowance to deduct points.");
            require(newsToken.balanceOf(msg.sender) >= penaltyAmount, "You don't have enough points to deduct.");
            newsToken.transferFrom(msg.sender, address(this), penaltyAmount); // 扣除积分
        }
    }
}
