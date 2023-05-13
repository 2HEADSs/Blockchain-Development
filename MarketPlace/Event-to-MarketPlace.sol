// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Event is ERC721, ERC721URIStorage, Ownable{
    using Counters for Counters.Counter;

    uint256 saleStart;
    uint256 saleEnd;
    uint256 ticketPrice;
    string metadata;

    Counters.Counter private _tokenIdCounter;



    constructor (
        uint256 _saleStart,
        uint256 _saleEnd,
        string memory _name,
        uint256 _ticketPric,
        string memory _metadata
    )ERC721("MyToken", "MTK") {
        saleStart = _saleStart;
        saleEnd = _saleEnd;
        ticketPrice = _ticketPric;
        metadata = _metadata;
    }

    function buyTicket(uint256 amount) external  {
           
    }

        function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
        function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

        function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }
}


