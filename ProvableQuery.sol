// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./provableAPI.sol";
import "./AccessControl.sol";
import "./AIGCStorage.sol";



contract ProvableQuery is usingProvable {
    AIGCStorage public storageContract; // 引用 AIGCStorage 合约

    event LogNewProvableQuery(string description);
    event LogNewsDataReceived(string news);
    AIGCStorage.NewsData public news_data;

    constructor(address _storageContractAddress) {
        storageContract = AIGCStorage(_storageContractAddress);
    }

    // 发起 Provable 查询
    function queryNews(string memory title, string memory content, string memory author) public {

        AIGCStorage.NewsData memory _newsData = AIGCStorage.NewsData({
            title: title,
            content: content,
            author: author
        });
        emit LogNewProvableQuery("Provable query sent, awaiting verification...");
        string memory apiUrl = string(abi.encodePacked("json(https://news-api.com/news?data=", _newsData.title, ").title"));
        provable_query("URL", apiUrl);
    }

    // Provable 回调函数
    function __callback(string memory result) public {
        require(msg.sender == provable_cbAddress(), "Provable callback only by Provable");

        emit LogNewsDataReceived(result);

        // 在这里解析新闻数据，您可以根据实际需要进行解析
        // 假设返回的数据是 JSON 格式
        // 这里只是一个示例，实际上需要更复杂的解析逻辑
        (string memory title, string memory content, string memory author) = parseNewsData(result);
        AIGCStorage.NewsData memory _newsData = AIGCStorage.NewsData({
            title: title,
            content: content,
            author: author
        });
        news_data = _newsData;
    }

    // 解析新闻数据的示例函数
    function parseNewsData(string memory rawData) internal pure returns (string memory, string memory, string memory) {
        // 假设 rawData 是 JSON 格式的字符串，包括 title、content 和 author 字段
        // 在实际应用中，您需要实现适当的 JSON 解析逻辑
         // 使用 abi.decode 函数来解析 JSON 格式的数据
        (string memory title, string memory content, string memory author) = abi.decode(
            bytes(rawData), (string, string, string)
        );
    
    return (title, content, author);
    }
}
