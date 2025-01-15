// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract InfoFeed {
    bool public passed = false;

    function info() external payable returns (uint256 result) {
        revert();
        result = 42;
    }

    receive() external payable {}

    fallback() external {
        passed = true;
    }
}

interface IMyInfoFeed {
    function infoTwo() external payable returns (uint256 result);
}

contract Consumer {
    IMyInfoFeed feed;

    function setFeed(IMyInfoFeed addr) public {
        feed = addr;
    }

    // function callFeed() public payable returns (uint256 feedResult) {
    //     feedResult = feed.info{value: 10, gas: 800}();
    // }

    function sendViaSend(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function callFeed() public payable {
        feed.infoTwo{value: msg.value}();
    }
}
