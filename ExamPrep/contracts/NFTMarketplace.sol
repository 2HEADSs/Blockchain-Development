// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


import "./NFT.sol";

contract NFTMarketplace is NFT {
    
    mapping (address => mapping(uint256=> uint256)) public nftPrice;

    function listNFTForSale(address collection, uint256 id, uint256 price) external{
        require(price !=0, "price must be greater than 0"); 
        require(nftPrice[collection][id]== 0, "NFT is already listed for sale");
        nftPrice[collection][id] = price;

        IERC721(collection).transferFrom(msg.sender, address(this), id);
    }
}
