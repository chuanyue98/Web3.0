// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./provableAPI.sol";
import "./ProvableQuery.sol";
import "./RewardManager.sol";
import "./AIGCStorage.sol";

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


    function verifyNews(AIGCStorage.NewsData memory news_data) view public returns (bool) {

        // 验证不同媒体源的信息是否匹配
        bool isVerified = compareStrings(news_data.title, verifiedNewsTitle) && compareStrings(news_data.content, verifiedNewsContent) && compareStrings(news_data.author, verifiedNewsAuthor);

        return isVerified;
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

}