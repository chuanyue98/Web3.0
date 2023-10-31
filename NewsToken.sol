// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NewsToken is ERC20 {
    constructor() ERC20("Newstoken", "NEWS") {
        _mint(msg.sender, 100000000 * 10 ** uint256(decimals())); // 初始化总供应量为 100,000,000 NEWSTOKEN
    }

}
