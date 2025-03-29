// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

library NumLib {
    function isEven(uint256 self) internal pure returns (bool) {
        return self % 2 == 0;
    }
}

contract ParityChecker {
    using NumLib for uint256;

    function checkParity(uint256 number) external pure returns (bool) {
        return number.isEven();
    }
}