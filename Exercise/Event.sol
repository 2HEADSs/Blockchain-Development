// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error NoMoreTickets();

contract Event is ERC721, Ownable {
    uint256 private _nextTokenId;

    // date is timestamp
    uint256 public immutable date;
    address public immutable organizer;

    string public location;
    uint256 public ticketAvailability;

    constructor(
        address minter,
        string memory eventName,
        uint256 date_,
        string memory location_,
        address organizer_
    ) ERC721(eventName, "MTK") Ownable(minter) {
        date = date_;
        location = location_;
        organizer = organizer_;
        _nextTokenId = 1;
    }

    function safeMint(address to) public onlyOwner {
        if (_nextTokenId == ticketAvailability) {
            revert NoMoreTickets();
        }
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override returns (address) {
        address from = _ownerOf(tokenId);

        // Perform (optional) operator check
        if (auth != address(0)) {
            _checkAuthorized(from, auth, tokenId);
        }

        // Execute the update
        if (from != address(0)) {
            // Clear approval. No need to re-authorize or emit the Approval event
            _approve(address(0), tokenId, address(0), false);

            unchecked {
                _balances[from] -= 1;
            }
        }

        if (to != address(0)) {
            unchecked {
                _balances[to] += 1;
            }
        }

        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        return from;
    }
}
