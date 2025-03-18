// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract TempConversation {
    function toFahrenheit(uint256 celsius) public pure returns (uint256) {
        return celsius + 32;
    }

    function toCelsius(uint256 fahrenheit) public pure returns (uint256) {
        return fahrenheit - 32;
    }
}
