// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/ownership/Ownable.sol";

struct Card {
    uint256 id;
    uint256 power;
    string name;
}

library CollectionLib {
    function exists(
        Card[] memory cards,
        uint256 id
    ) internal pure returns (bool doesExist) {
        uint256 cardsLength = cards.length;
        assert(cardsLength < 10000);
        for (uint256 i = 0; i < cardsLength; i++) {
            if (cards[i].id == id) {
                return true;
            }
        }
    }
}

contract CollectibleCardLibrary {
    using CollectionLib for Card[];
    mapping(address => Card[]) public collections;

    error AlreadyExist();

    function addCard(uint256 id, uint256 power, string calldata name) external {
        // CollectionLib.exists(collections[msg.sender], id);
        if (collections[msg.sender].exists(id)) {
            revert();
        }
        Card memory newCard = Card({id: id, power: power, name: name});
        collections[msg.sender].push(newCard);
    }
}
