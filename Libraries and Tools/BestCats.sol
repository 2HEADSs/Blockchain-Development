// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BestCats is ERC721 {
    constructor() ERC721("Best Cats", "BS") {}

    uint256 public constant maxSupply = 12;
    uint256 constant price = 0.5 ether;
    uint256 nextToken;

    function _baseURI() internal pure override returns (string memory) {
        return "https://bestcats.com/cats/";
    }

    function buyNFT() external payable {
        require(msg.value == price, "Insufficient value");

        _mint(msg.sender, nextToken);
        nextToken++;
    }

    function tokenURI(uint256 tokenID)
        public
        view
        override
        returns (string memory)
    {
        return string.concat(super.tokenURI(tokenID), ".json");
    }
}
