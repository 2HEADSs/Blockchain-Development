// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Animal {
    function sound() public pure virtual returns (string memory) {
        return "I am animal";
    }
}

contract Cat is Animal {
    function sound() public pure virtual override returns (string memory) {
        return string(abi.encodePacked(super.sound(), ", Meow"));
    }
}

contract SuperCat is Animal, Cat {
    function sound() public pure override(Animal, Cat) returns (string memory) {
        return string(abi.encodePacked(super.sound(), ",  and I am super"));
    }
}
