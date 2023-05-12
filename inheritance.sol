// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Animal {
    function live() external pure returns (bool) {
        return true;
    }
}

contract Dog is Animal {
    function bark() external pure returns (uint256) {
        return 1;
    }
}

contract MyAnimal is Dog {}
