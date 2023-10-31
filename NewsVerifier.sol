// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./provableAPI.sol";
import "./ProvableQuery.sol";

contract NewsVerifier is usingProvable {
    string public verifiedNewsTitle;
    string public verifiedNewsContent;
    string public verifiedNewsAuthor;
    ProvableQuery provableQuery;

    event LogNewProvableQuery(string description);
    event LogNewsVerified(bool success, string description);
    event NewsVerificationFailed(string description);

    constructor(address _provableQuery) {
        provable_setProof(proofType_TLSNotary | proofStorage_IPFS);
        provableQuery = ProvableQuery(_provableQuery);
    }

    function uploadNews(string memory title, string memory content, string memory author) public {
        // 用户上传新闻，包括标题、内容和作者
        // 这里可以包括访问控制和用户身份验证逻辑
        string memory newsData = string(abi.encodePacked(title, content, author));
        bytes32 dataHash = keccak256(abi.encodePacked(newsData));
        emit LogNewProvableQuery("Provable query sent, awaiting verification...");
        
        provableQuery.queryNews(title,content,author);
    }


    function verifyNews(string memory title, string memory content, string memory author) public returns (bool) {
        // 替换为实际的 API 调用来获取不同媒体源的新闻信息


        // 验证不同媒体源的信息是否匹配
        bool isVerified = compareStrings(title, verifiedNewsTitle) && compareStrings(content, verifiedNewsContent) && compareStrings(author, verifiedNewsAuthor);

        if (isVerified) {
            // 如果验证通过，将相关数据存储到状态变量中
            // 例如：verifiedNewsTitle = title; verifiedNewsContent = content; verifiedNewsAuthor = author;
        } else {
            // 如果验证失败，可以采取适当的措施，例如触发事件
            emit NewsVerificationFailed("News verification failed for the provided data.");
        }

        return isVerified;
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

}