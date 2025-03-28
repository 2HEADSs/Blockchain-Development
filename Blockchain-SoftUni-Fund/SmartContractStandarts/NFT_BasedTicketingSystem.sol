// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract NFT_BasedTicketingSystem is ERC721, Ownable {
    uint256 public ticketId;
    address public contractOwner;

    struct TicketInfo {
        string eventName;
        uint256 eventDate;
        string seatNumber;
    }

    mapping(uint256 => TicketInfo) public ticketDetails;
    mapping(uint256 => bool) public allowedForRelease;
    mapping(uint256 => address) public ticketOwners;

    error NotAllowed();
    error NotOwner();

    constructor()
        ERC721("NFT Based Ticket System", "NTTS")
        Ownable(msg.sender)
    {
        contractOwner = msg.sender;
    }

    function mintNft(
        address _buyer,
        string calldata _eventName,
        uint256 _eventDate,
        string calldata _seatNumber
    ) external onlyOwner {
        ticketDetails[ticketId] = TicketInfo({
            eventName: _eventName,
            eventDate: _eventDate,
            seatNumber: _seatNumber
        });
        _safeMint(_buyer, ticketId);
        ticketOwners[ticketId] = _buyer;
        ticketId++;
    }

    function allowResale(uint256 _ticketId, bool _isAllowed)
        external
        onlyOwner
    {
        allowedForRelease[_ticketId] = _isAllowed;
    }

    function transferTicket(address _to, uint256 _ticketId) external {
        if (msg.sender != contractOwner) {
            if (!allowedForRelease[_ticketId]) {
                revert NotAllowed();
            }
        }

        require(_ownerOf(_ticketId) == msg.sender, "Not the owner");
        _approve(_to, _ticketId, msg.sender);
        safeTransferFrom(msg.sender, _to, _ticketId);
        ticketOwners[_ticketId] = _to;
    }
}
