// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract CrowdFunding {
    mapping(address => uint256) public shares;

    function addShares(address receiver) external {
        shares[receiver] += 1000;
    }
}

contract testFixedArray {
    uint256[5] public arr = [1, 2, 3, 4, 5];

    function addNumber() external view returns (uint256) {
        uint256 res;
        for (uint256 i = 0; i < arr.length; i++) {
            res += arr[i];
        }
        return res;
    }
}

