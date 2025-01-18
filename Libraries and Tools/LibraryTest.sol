// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {MathLib} from "./MathLib.sol";

contract Calculator {
    using MathLib for uint256;
    function addDirectCall(uint256 a, uint256 b) public pure returns (uint256) {
        return a.add(b);
    }
}
