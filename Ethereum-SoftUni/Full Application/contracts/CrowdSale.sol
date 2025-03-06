// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract CrowdSale is Ownable {
    uint256 public startTime;
    error NotStardet();

    constructor(uint256 _startTime) Ownable(msg.sender) {
        require(
            _startTime > block.timestamp,
            "CrowdSale: Start time must be in the future"
        );
        startTime = _startTime;
    }
}
