// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

error UserDoesNotHaveCardCollection();
error IndexOutOfBones();

struct Card {
    uint256 id;
    uint256 power;
    string name;
}

library CollectionLib {
    function existsById(Card[] memory cards, uint256 id)
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

    function existByIndex(Card[] memory cards, uint256 index)
        internal
        pure
        returns (bool)
    {
        return cards.length > index;
    }

    function removeCard(Card[] memory cards, uint256 index)
        internal
        pure
        returns (Card[] memory)
    {
        Card[] memory temporaryCcards = new Card[](cards.length - 1);
        uint256 newIndex = 0;
        for (uint256 i = 0; i < cards.length; i++) {
            if (i != index) {
                temporaryCcards[newIndex] = cards[i];
                newIndex++;
            }
        }
        return temporaryCcards;
    }
}

contract CollectibleCardLibrary is Ownable, AccessControl {
    using CollectionLib for Card[];
    mapping(address => Card[]) public collections;

    constructor(address initialOwner) Ownable(initialOwner) {
        _transferOwnership(initialOwner);
    }

    error AlreadyExist();

    function addCard(
        uint256 id,
        uint256 power,
        string calldata name
    ) external {
        // CollectionLib.exists(collections[msg.sender], id);
        if (collections[msg.sender].existsById(id)) {
            revert();
        }
        Card memory newCard = Card({id: id, power: power, name: name});
        collections[msg.sender].push(newCard);
    }

    function removeAtIndex(uint256 index, address holder) external onlyOwner {
        if (collections[holder].length <= 0) {
            revert UserDoesNotHaveCardCollection();
        }
        if (!collections[holder].existByIndex(index)) {
            revert IndexOutOfBones();
        }
        Card[] memory newCards = collections[holder].removeCard(index);
        delete collections[holder];

        for (uint256 i = 0; i < newCards.length; i++) {
            collections[holder].push(newCards[i]);
        }
    }
}
