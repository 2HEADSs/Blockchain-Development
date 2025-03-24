// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract Math {
    function sum(uint256 a, uint256 b) internal pure returns (uint256 result) {
        result = a + b;
    }
}

// Child (Derived) contract
contract Voting is Math {
    uint256 public positiveVotes;
    uint256 public negativeVotes;

    function vote(bool position) external {
        if (position) {
            positiveVotes = sum(positiveVotes, 1);
        } else {
            negativeVotes = sum(negativeVotes, 1);
        }
    }
}

contract A {
    uint256 public x = 5;
}

contract B is A {
    uint256 public y = 10; // Уникално име, няма shadowing
}

contract C is B {
    uint256 public z = 15; // Уникално име, няма shadowing
}

abstract contract Animal {
    uint256 public age;

    function eat() public pure virtual returns (string memory) {
        return "Nom nom";
    }

    function speak() public virtual returns (string memory);
}

contract Dog is Animal {
    function speak() public override returns (string memory) {
        age = 2;
        return "Woof";
    }
}

contract InfoFeed {
    function info() public payable returns (uint256 result) {
        result = 42;
    }
}
error CallFailed();
contract Consumer {
    address feedAddr;

    function setFeed(address _feedAddr) external {
        feedAddr = _feedAddr;
    }

    function callFeed() public payable returns (uint256 feedResult) {
        bytes memory funcSelector = abi.encodeWithSignature("info()");
        (bool ok, bytes memory data) = feedAddr.call{value: 10, gas: 800}(
            funcSelector
        );
        if (!ok) revert CallFailed();
        feedResult = abi.decode(data, (uint256));
    }
}
