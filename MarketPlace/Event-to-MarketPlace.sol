// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Event is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    string constant _METADATA = "https://api.jsonbin.io/v3/b/6459ebf3b89b1e22999a05f0?meta=false";

    Counters.Counter private _tokenIdCounter;

    uint256 public saleStart;
    uint256 public saleEnd;
    uint256 public ticketPrice;
    uint256 public maxTickets;
    string public metadata;
    address public randomWinner;

    constructor(
        uint256 _saleStart,
        uint256 _saleEnd,
        uint256 _ticketPric,
        uint256 _maxTickets,
        string memory _metadata
    ) ERC721("MyToken", "MTK") {
        require(_saleEnd > _saleStart, "Invalid data");
        require(_ticketPric > 0, "Invalid price");
        require(_ticketPric > 0, "Invalid price");
        saleStart = _saleStart;
        saleEnd = _saleEnd;
        ticketPrice = _ticketPric;
        maxTickets = _maxTickets;
        metadata = _metadata;
    }

    function buyTicket(uint256 amount) external payable {
        require(amount < 50, "TOO BIG AMOUNT");
        require(amount * ticketPrice == msg.value, "Insufficient value");

        if (maxTickets > 0) {
            require(_tokenIdCounter.current() + amount <= maxTickets, "Too many NFTs");
        }

        for (uint256 i = 0; i < amount; i++) {
            _safeMint(msg.sender, _METADATA);
        }
    }

    function withdraw() external onlyOwner {
        require(block.timestamp > saleEnd, "Too early");
        _chooseRandomWinner();
        payable(owner()).transfer(address(this).balance);
    }

    function _chooseRandomWinner() internal {
        require(randomWinner == address(0), "already chosen");
        randomWinner = _ownerOf((block.prevrandao % _tokenIdCounter.current()) - 1);

        _safeMint(randomWinner, _METADATA);
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

    function _safeMint(address to, string memory uri) private {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }
}
