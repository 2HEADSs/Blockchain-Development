// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract DigitalLibrary {
    enum Status {
        Active,
        Outdated,
        Archived
    }

    struct EBook {
        string title;
        string author;
        uint256 publicationDate;
        uint256 expirationDate;
        Status status;
        address primaryLibrarian;
        uint256 readCount;
    }

    mapping(uint256 => EBook[]) books;

    uint256[] public allBooks;

    EBook[] booksList;

    modifier validIndex(uint256 bookIndex) {
        require(
            bookIndex >= 0 && bookIndex < booksList.length,
            "Invalid Index"
        );
        _;
    }
    modifier validAuthorizedLibrarioan(uint256 bookIndex) {
        bool isAutohrized = false;
        for (
            uint256 i = 0;
            i < booksList[bookIndex].authorizedLibrarians.length;
            i++
        ) {
            if (booksList[bookIndex].authorizedLibrarians[i] == msg.sender) {
                isAutohrized = true;
                break;
            }
        }
        require(isAutohrized, "Not authorized");
        _;
    }

    function createBook(
        string calldata title,
        string calldata author,
        uint256 publicationDate
    ) public {
        // Създаване на нова книга
        EBook memory newBook = EBook({
            title: title,
            author: author,
            publicationDate: publicationDate,
            expirationDate: block.timestamp + 180 days,
            status: Status.Active,
            primaryLibrarian: msg.sender,
            readCount: 0,
            authorizedLibrarians: new address[]
        });

        books[allBooks.length - 1] = newBook;

        allBooks.push(bookId);
    }

    function addLibrarian(address newLibrarian, uint256 bookIndex)
        public
        validIndex(bookIndex)
    {
        require(
            msg.sender == booksList[bookIndex].primaryLibrarian,
            "Only Primary Librarian can add Authorized Librarians"
        );
        booksList[bookIndex].authorizedLibrarians.push(newLibrarian);
    }

    function extendExpirationDate(uint256 bookIndex, uint256 newExpirationDate)
        public
        validIndex(bookIndex)
        validAuthorizedLibrarioan(bookIndex)
    {
        booksList[bookIndex].expirationDate =
            block.timestamp +
            newExpirationDate;
    }

    function changeStatus(uint256 newStatus, uint256 bookIndex)
        public
        validIndex(bookIndex)
    {
        require(
            msg.sender == booksList[bookIndex].primaryLibrarian,
            "Only Primary Librarian can add Authorized Librarians"
        );
        booksList[bookIndex].status = Status(newStatus);
    }
}
