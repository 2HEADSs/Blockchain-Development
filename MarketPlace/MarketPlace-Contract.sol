// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Event-to-MarketPlace.sol";


contract Marketplace {
    address [] public  events;

    event NewEvent(address creator, address eventAddr);
    
    function createEvent() external {
        address newEvent = address (new Event());

        events.push(newEvent);

        emit NewEvent(msg.sender,newEvent);
    }
}