// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

enum Status {
    Active,
    Outdated,
    Archived
}

struct EBook {
    string title;
    address author;
    uint256 publicationDate;
    uint256 expirationDate;
    Status status;
    address primaryLibrarian;
    uint256 readCount;
    address[] authorizedLibrarians;
}

error TitleShouldNotBeEmpty();
error YouAreNotAuthorized();
error NoSuchBook();
error BookIsOutdated();
error BookIsArchived();

contract DigitalLibrary3 {
    mapping(uint256 => EBook) public eBooks;
    uint256 internal nextId = 1;

    function createEBook(
        string memory _title,
        uint256 _expirationDate,
        Status _status
    ) external {
        if (bytes(_title).length == 0) {
            revert TitleShouldNotBeEmpty();
        }

        EBook memory eBook = EBook({
            title: _title,
            author: msg.sender,
            publicationDate: block.timestamp,
            expirationDate: block.timestamp + _expirationDate,
            status: _status,
            primaryLibrarian: msg.sender,
            readCount: 0,
            authorizedLibrarians: new address[](0)
        });

        eBooks[nextId] = eBook;
        nextId += 1;
    }
    function viewBook(
        uint256 bookId
    )
        public
        view
        returns (
            address,
            string memory,
            uint256,
            uint256,
            string memory,
            address,
            uint256,
            address[] memory
        )
    {
        EBook storage eBook = eBooks[bookId];

        if (eBook.status == Status.Outdated) {
            revert BookIsOutdated();
        }

        if (eBook.status == Status.Archived) {
            revert BookIsArchived();
        }

        return (
            eBook.author,
            eBook.title,
            eBook.publicationDate,
            eBook.expirationDate,
            statusToString(eBook.status),
            eBook.primaryLibrarian,
            eBook.readCount,
            eBook.authorizedLibrarians
        );
    }

    function addLibrarian(address librarian, uint256 bookId) public {
        EBook storage eBook = eBooks[bookId];
        if (eBook.primaryLibrarian != msg.sender) {
            revert YouAreNotAuthorized();
        }
        if (eBook.publicationDate == 0) {
            revert NoSuchBook();
        }

        eBook.authorizedLibrarians.push(librarian);
    }

    function extendDate(uint256 bookId, uint256 newDate) public {
        EBook storage eBook = eBooks[bookId];
        if (eBook.publicationDate == 0) {
            revert NoSuchBook();
        }
        bool hasAuthorized;
        for (uint256 i = 0; i < eBook.authorizedLibrarians.length; i++) {
            if (msg.sender == eBook.authorizedLibrarians[i]) {
                hasAuthorized = true;
                break;
            }
        }
        if (!hasAuthorized) {
            revert YouAreNotAuthorized();
        }

        eBook.expirationDate = block.timestamp + newDate;
    }

    function changeStatus(uint256 bookId, Status newStatus) public {
        EBook storage eBook = eBooks[bookId];
        if (eBook.primaryLibrarian != msg.sender) {
            revert YouAreNotAuthorized();
        }
        eBook.status = newStatus;
    }

    function statusToString(
        Status status
    ) internal pure returns (string memory) {
        if (status == Status.Active) {
            return "Active";
        } else if (status == Status.Outdated) {
            return "Outdated";
        } else {
            return "Archived";
        }
    }
}
