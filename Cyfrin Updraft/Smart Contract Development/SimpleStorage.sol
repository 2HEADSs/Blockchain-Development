// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract SimpleStorage {
    uint256 myFavoriteNumber;

    // uint256[] favoriteNumbers;
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public listOfPeople;

    // Person public pat = Person({favoriteNumber: 7, name: "Pat"});
    // Person public mariah = Person({favoriteNumber: 16, name: "Mariah"});
    // Person public jon = Person({favoriteNumber: 12, name: "Jon"});

    // Person public pat = Person(7, "Pat");

    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    }

    function retrive() public view returns (uint256) {
        return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        listOfPeople.push(Person(_favouriteNumber, _name));
    }
}
