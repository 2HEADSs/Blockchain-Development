// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Base1 {
    uint256 public baseOne;

    constructor(uint256 newBaseOne) {
        baseOne = newBaseOne;
    }
}

contract Base2 {
    uint256 public baseTwo;

    constructor(uint256 newBaseTwo) {
        baseTwo = newBaseTwo;
    }
}

contract Derived1 is Base1, Base2 {
    constructor(uint256 newBaseOne, uint256 newBaseTwo) Base1(newBaseOne) Base2(newBaseTwo) {}
}
