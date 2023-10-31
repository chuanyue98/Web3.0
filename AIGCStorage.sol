// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./AccessControl.sol";

contract AIGCStorage is AccessControl {

    struct NewsData {
    string title;
    string content;
    string author;
    }
    // AIGC 数据条目的结构
    struct AIGCEntry {
        address dataProvider; // 数据提供者的地址
        NewsData newsData; // 新闻数据的内容
        bytes32 newsHash; // 新闻数据的哈希值
        uint256 timestamp; // 存储数据的时间戳
        bool isVerified; // 数据验证状态
    }

    // 存储 AIGC 数据的映射，以哈希值为键，对应 AIGCEntry 为值
    mapping(bytes32 => AIGCEntry) public aigcEntries;

    // 存储 AIGC 数据
    function storeAIGC(
        address _dataProvider,
        NewsData memory _newsData,
        bytes32 _newsHash
    ) public onlyAuthorized {
        // 创建 AIGC 数据条目并存储到映射中
        aigcEntries[_newsHash] = AIGCEntry({
            dataProvider: _dataProvider,
            newsData: _newsData,
            newsHash: _newsHash,
            timestamp: block.timestamp,
            isVerified: false // 初始时设置为未验证
        });
    }

    // 更新数据验证状态
    function updateVerificationStatus(bytes32 _newsHash, bool _isVerified) public onlyAuthorized {
        // 根据哈希值更新数据验证状态
        aigcEntries[_newsHash].isVerified = _isVerified;
    }
}
