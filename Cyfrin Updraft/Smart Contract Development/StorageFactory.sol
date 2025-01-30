// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStoragesContracts;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStoragesContracts.push(newSimpleStorageContract);
    }

    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _newSimpleStorageNumber
    ) public {
        // SimpleStorage mySimpleStorage = listOfSimpleStoragesContracts[
        //     _simpleStorageIndex
        // ];
        // mySimpleStorage.store(_newSimpleStorageNumber);

        listOfSimpleStoragesContracts[_simpleStorageIndex].store(
            _newSimpleStorageNumber
        );
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        // SimpleStorage mySimpleStorage = listOfSimpleStoragesContracts[
        //     _simpleStorageIndex
        // ];
        // return mySimpleStorage.retrieve();
        return listOfSimpleStoragesContracts[_simpleStorageIndex].retrieve();
    }
}
