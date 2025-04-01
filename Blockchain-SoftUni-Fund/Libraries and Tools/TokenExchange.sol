// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UniCoin is ERC20 {
    uint256 nextToken;
    mapping(address => uint256) public UniCoinByOwner;

    //"UniCoin ", "SC"
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
        UniCoinByOwner[to] += 1;
        nextToken++;
    }
}

contract TokenExchange is ERC20 {
    uint256 nextToken;
    mapping(address => uint256) public SoftCoinsByOwner;
    mapping(address => uint256) public UniCoinsByOwner;
    uint256 priceInSoftCoins = 2;

    constructor() ERC20("SoftCoin ", "SC") {}

    function mint(address to) external {
        _mint(to, nextToken);
        nextToken++;
        SoftCoinsByOwner[msg.sender] += 1;
    }

    //"UniCoin ", "SC"
    function buyUniCoins() public {
        if (SoftCoinsByOwner[msg.sender] < priceInSoftCoins) {
            revert();
        }

        SoftCoinsByOwner[msg.sender] -= 2;
        new UniCoin("UniCoin ", "SC");
        UniCoinsByOwner[msg.sender] += 1;
    }
}
