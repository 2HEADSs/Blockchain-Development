// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract ArithmeticCalculator {
    function add(uint256 firstNum, uint256 secondNum)
        public
        pure
        returns (uint256)
    {
        return firstNum + secondNum;
    }

    function subtract(uint256 firstNum, uint256 secondNum)
        public
        pure
        returns (uint256)
    {
        return firstNum - secondNum;
    }

    function multiply(uint256 firstNum, uint256 secondNum)
        public
        pure
        returns (uint256)
    {
        return firstNum * secondNum;
    }

    function divide(uint256 firstNum, uint256 secondNum)
        public
        pure
        returns (uint256)
    {
        if (firstNum <= 0 || secondNum <= 0) {
            revert("Use positive nums");
        }

        if (firstNum < secondNum) {
            revert("Divide function can return only positive nums");
        }
        return firstNum / secondNum;
    }
}
