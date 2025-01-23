// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Event} from "./Event.sol";

error InvalidInput(string info);
error AlreadyListed();
error MustBeOrganizer();
error WrongdBuyingOptiion();
error ProfitDistributionFailed();

enum BuyingOptiion {
    FixedPrice,
    Bidding
}

struct EventData {
    uint256 ticketPrice;
    BuyingOptiion salesType;
    uint256 salesEnds; //timestamp
}

contract Marketplace {
    uint256 public constant MIN_SALE_PERIOD = 24 hours;
    uint256 public constant SALE_FEE = 0.1 ether;

    address public immutable feeCollector;

    mapping(address => EventData) public events;
    mapping(address => uint256) public profits;
    mapping(address => mapping(uint256 => bool)) public secondMarketListenings;

    event NewEvent(address indexed newEvent);

    constructor(address feeCollector_) {
        feeCollector = feeCollector_;
    }

    function createEvent(
        string memory eventName,
        uint256 date,
        string memory location,
        uint256 ticketPrice,
        BuyingOptiion salesType,
        uint256 salesEnd,
        uint256 ticketAvailability_,
        bool isPriceCapSet_,
        address whitelistedAddress_
    ) external {
        address newEvent = address(
            new Event(
                address(this),
                eventName,
                date,
                location,
                msg.sender,
                ticketAvailability_,
                isPriceCapSet_,
                whitelistedAddress_
            )
        );

        emit NewEvent(newEvent);

        _listEvent(newEvent, ticketPrice, salesType, salesEnd);
    }

    function listEvent(
        address newEvent,
        uint256 ticketPrice,
        BuyingOptiion salesType,
        uint256 salesEnd
    ) external {
        if (msg.sender != Event(newEvent).organizer()) {
            revert MustBeOrganizer();
        }

        _listEvent(newEvent, ticketPrice, salesType, salesEnd);
    }

    function _listEvent(
        address newEvent,
        uint256 ticketPrice,
        BuyingOptiion salesType,
        uint256 salesEnd
    ) internal {
        if (salesEnd < block.timestamp + MIN_SALE_PERIOD) {
            revert InvalidInput("salesEnd is invalid");
        }
        if (ticketPrice < SALE_FEE) {
            revert InvalidInput("ticketPrice>=SALE_FEE");
        }
        if (events[newEvent].salesEnds != 0) {
            revert AlreadyListed();
        }

        events[newEvent] = EventData({
            ticketPrice: ticketPrice,
            salesType: salesType,
            salesEnds: salesEnd
        });
    }

    function buyOnSecodMarket(
        address event_,
        uint256 ticketId,
        address owner
    ) external payable {
        if (events[event_].salesType != BuyingOptiion.FixedPrice) {
            revert WrongdBuyingOptiion();
        }

        if (msg.value != events[event_].ticketPrice) {
            revert InvalidInput("Wrong value");
        }

        profits[Event(event_).organizer()] += msg.value - SALE_FEE;
        profits[feeCollector] += SALE_FEE;

        Event(event_).safeTransferFrom(owner, msg.sender, ticketId);
    }

    function buyTicket(address event_) external payable {
        if (events[event_].salesType != BuyingOptiion.FixedPrice) {
            revert WrongdBuyingOptiion();
        }

        if (msg.value != events[event_].ticketPrice) {
            revert InvalidInput("Wrong value");
        }
        profits[Event(event_).organizer()] += msg.value - SALE_FEE;
        profits[feeCollector] += SALE_FEE;

        Event(event_).safeMint(msg.sender);
    }

    function withdrawProfit(address to) external payable {
        uint256 profit = profits[msg.sender];
        profits[msg.sender] = 0;

        (bool succes, ) = to.call{value: profit}("");
        if (!succes) {
            revert ProfitDistributionFailed();
        }
    }
}
