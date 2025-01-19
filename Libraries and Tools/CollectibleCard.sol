// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

struct Card {
    uint256 id;
    uint256 power;
    string name;
}

library CollectionLib {
    function exists(Card[] memory cards, uint256 id)
        internal
        pure
        returns (bool)
    {
        uint256 cardsLength = cards.length;
        assert(cardsLength < 10000);
        for (uint256 i = 0; i < cardsLength; i++) {
            if (cards[i].id == id) {
                return true;
            }
        }
        return false;
    }
}

contract CollectibleCardLibrary {
    using CollectionLib for Card[];
    mapping(address => Card[]) public collections;

    error AlreadyExist();

    function addCard(
        uint256 id,
        uint256 power,
        string calldata name
    ) external {
        if (collections[msg.sender].exists(id)) {
            revert();
        }
        Card memory newCard = Card({id: id, power: power, name: name});
        collections[msg.sender].push(newCard);
    }
}
