// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;
struct Dog {
    uint256 weight;
    uint256 age;
}

contract test2 {
    uint256[] public arr = [1, 2, 3, 4, 6];
    Dog public bark;
    function checkArr(uint256[] calldata _arr) public returns (uint256) {
        uint256[] memory arr2 = new uint256[](2); // Създава динамичен масив с дължина 2
        uint256[] storage arr3 = arr; // Създава динамичен масив с дължина 2
        arr2[0] = 2;
        arr2[1] = 3;

        arr[0] = _arr[0];
        return _arr[0];
    }

    function test3() public {
        Dog memory barkCloning = bark;
    }
}
