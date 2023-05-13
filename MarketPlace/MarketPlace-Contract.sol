import "./Event-to-MarketPlace.sol";

contract Marketplace {
    address[] public events;

    event NewEvent(address creator, address eventAddr);

    function createEvent(
        uint256 _saleStart,
        uint256 _saleEnd,
        uint256 _ticketPric,
        uint256 _maxTickets,
        string memory _metadata
    ) external {
        address newEvent = address(new Event(_saleStart, _saleEnd, _ticketPric,_maxTickets, _metadata));

        events.push(newEvent);

        emit NewEvent(msg.sender, newEvent);
    }
}
