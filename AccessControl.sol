// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract AccessControl {
    //引入权限控制，经授权才可执行一定合约
    address public owner;
    mapping(address => bool) public authorizedUsers;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Insufficient permissions");
        _;
    }

    modifier onlyAuthorized() {
        require(msg.sender == owner || authorizedUsers[msg.sender], "Insufficient permissions");
        _;
    }

    function addAuthorizedUser(address user) public onlyOwner {
        authorizedUsers[user] = true;
    }
}
