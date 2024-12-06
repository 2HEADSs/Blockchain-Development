// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract InfoFeed {
    function info() external payable returns (uint256 result) {
        result = 42;
    }
}

contract Consumer {
    InfoFeed feed;

    function setFeed(InfoFeed addr) public {
        feed = addr;
    }

    function callFeed() public payable returns (uint256 feedResult) {
        feedResult = feed.info{value: 10, gas: 800}();
    }
}
