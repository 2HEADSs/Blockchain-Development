// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Test {
    uint256[5] public arr = [1, 2, 3, 4, 5];
    uint256 a;

    function sumNums() external view returns (uint256) {
        uint256 res;
        for (uint256 i = 0; i < arr.length; i++) {
            res += arr[i];
        }
    }

    function storageArray() external {
        // get reference
        uint[5] storage numbers = arr;

        // make copy
        // uint[5] memory numbers = arr;

        numbers[1] = 2;
    }
}
