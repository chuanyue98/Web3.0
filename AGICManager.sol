// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./AIGCStorage.sol";
import "./ProvableQuery.sol";
import "./NewsVerifier.sol";
import "./RewardManager.sol";
import "./AccessControl.sol";
import "./NewsToken.sol";

contract AIGCManager is AccessControl {
    AIGCStorage public storageContract;
    ProvableQuery public provableQuery;
    NewsVerifier public newsVerifier;
    RewardManager public rewardManager;
    NewsToken public newsToken; 

    constructor(
        address _storageContract,
        address _provableQuery,
        address _newsVerifier,
        address _rewardManager,
        address _newsToken
    ) {
        storageContract = AIGCStorage(_storageContract);
        provableQuery = ProvableQuery(_provableQuery);
        newsVerifier = NewsVerifier(_newsVerifier);
        rewardManager = RewardManager(_rewardManager);
        newsToken = NewsToken(_newsToken);
    }

    // 新闻上传功能
    function uploadNews(string memory title, string memory content, string memory author) public onlyAuthorized {
        //授权给合约一定Token，以便后续对节点进行奖惩
        uint256 requiredAllowance = 1 ether;

        require(newsToken.allowance(msg.sender,address(rewardManager)) >= requiredAllowance);
        // 计算新闻数据哈希
        bytes32 newsHash = keccak256(abi.encodePacked(title,content,author));
        // 存储新闻数据
        AIGCStorage.NewsData memory _newsData = AIGCStorage.NewsData({
            title: title,
            content: content,
            author: author
        });
        storageContract.storeAIGC(msg.sender, _newsData, newsHash);
        // 触发Provable查询
        provableQuery.queryNews(title, content, author);

        bool isVerified;
        isVerified = newsVerifier.verifyNews(_newsData);

        rewardManager.processReward(msg.sender,isVerified);

    }

}
