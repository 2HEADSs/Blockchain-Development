pragma solidity ^0.8.4;

contract Event {
    uint256 saleStart;
    uint256 saleEnd;
    string name;
    uint256 ticketPrice;
    string metadata;

    constructor(
        uint256 _saleStart,
        uint256 _saleEnd,
        string memory _name,
        uint256 _ticketPric,
        string memory _metadata
    ) {
        saleStart = _saleStart;
        saleEnd = _saleEnd;
        name = _name;
        ticketPrice = _ticketPric;
        metadata = _metadata;
    }
}
