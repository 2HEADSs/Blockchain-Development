// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract HomeRepairService {
    address public owner;
    uint256 id;
    string public description = "Fix roof leak";
    mapping(uint256 => string) internal requests;
    mapping(uint256 => bool) public acceptedRequest;


    constructor() {
        owner = msg.sender;
    }
    //1. Add a repair request
    function addRepairRequest(
        string memory requestDesription,
        uint256 requestId
    ) external {
        requests[requestId] = requestDesription;
        acceptedRequest[requestId] = false;
    }
    //2. Accept a repair request
    function acceptRepairRequest(uint256 requestId) public {
        acceptedRequest[requestId] = true;
    }

    //3. Add a payment

    // function addPayment(uint256 requestId) public {
    //     acceptedRequest[requestId] = true
    // }
}
