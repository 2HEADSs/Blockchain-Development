// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract DigitalLibrary {
    enum Status {
        Active,
        Outdated,
        Archived
    }

    struct EBook {
        uint256 id;
        string title;
        string author;
        uint256 publicationDate;
        uint256 expirationDate;
        Status status;
        address primaryLibrarian;
        uint256 readCount;
        address[] authorizedLibrarians;
    }

    EBook[] public books;

    function createBook(
        string calldata title_,
        string calldata author_,
        uint256 publicationDate_,
        uint256 expirationDate_,
        Status status_,
        address primaryLibrarian_
    ) public returns (uint256 bookId, string memory bookTitle) {
        uint256 id_ = books.length;

        EBook memory book = EBook({
            id: id_,
            title: title_,
            author: author_,
            publicationDate: publicationDate_,
            expirationDate: expirationDate_,
            status: status_,
            primaryLibrarian: primaryLibrarian_,
            readCount: 0,
            authorizedLibrarians: new address[](0)
        });
        books.push(book);

        return (id_, title_);
    }

    // mapping (uint256 => address[]) authorizedLibrarians;

    function addAuthorizedLibrarians(address newAuthorizer, uint256 bookId)
        public
        returns (bool success)
    {
        EBook storage book = books[bookId];
        if (msg.sender != book.primaryLibrarian) {
            revert("Only primary librarian can add authorized librarians!");
        }

        book.authorizedLibrarians.push(newAuthorizer);
        return true;
    }

    function dateManagement(uint256 bookId, uint256 newDate) public {
        EBook storage book = books[bookId];
        bool hasAuthorized;
        if (msg.sender == book.primaryLibrarian) {
            hasAuthorized = true;
        }
        for (uint256 i = 0; i < book.authorizedLibrarians.length; i++) {
            if (msg.sender == book.authorizedLibrarians[i]) {
                hasAuthorized = true;
                break;
            }
        }
        if(hasAuthorized){
            book.expirationDate = newDate;
        } else {
            revert("Not authorized.");
        }

    }
}
