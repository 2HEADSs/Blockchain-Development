// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

// import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CrowdFunding2 is ERC20 {
    uint256 public immutable price;
    error InsuficientAmount();

    constructor(uint256 _price) ERC20("CrowdFunding", "CF") {
        price = _price;
    }
    function buyShares() external payable {
        uint256 sharesToReceive = msg.value / price;
        _mint(msg.sender, sharesToReceive);
    }
}
