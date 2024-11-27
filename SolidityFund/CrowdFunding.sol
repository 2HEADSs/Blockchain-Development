// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract CrowdFunding {
    mapping(address => uint256) public shares;

    function addShares(address receiver) external {
        shares[receiver] += 1000;
    }
}
