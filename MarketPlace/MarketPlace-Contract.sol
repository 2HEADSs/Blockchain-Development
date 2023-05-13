// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Event-to-MarketPlace.sol";

contract Marketplace {
    address[] public events;

    event NewEvent(address creator, address eventAddr);

    function createEvent(
        uint256 _saleStart,
        uint256 _saleEnd,
        uint256 _ticketPric,
        string memory _metadata
    ) external {
        address newEvent = address(
            new Event(_saleStart, _saleEnd, _name, _ticketPric, _metadata)
        );

        events.push(newEvent);

        emit NewEvent(msg.sender, newEvent);
    }
}
