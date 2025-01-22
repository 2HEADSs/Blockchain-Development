// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error NoMoreTickets();

contract Event is ERC721, Ownable {
    uint256 private _nextTokenId;

    // date is timestamp
    uint256 public immutable date;
    string public location;
    uint256 public ticketAvailability;

    constructor(
        address minter,
        string memory eventName,
        string memory location_,
        uint256 date_
    ) ERC721(eventName, "MTK") Ownable(minter) {
        date = date_;
        location = location_;
    }

    function safeMint(address to) public onlyOwner {
        if (_nextTokenId == ticketAvailability) {
            revert NoMoreTickets();
        }
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }
}
