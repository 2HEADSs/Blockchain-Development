// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

abstract contract PaymentProcessorBase {
    address public owner;
    uint256 public storeBalance;
    struct Product {
        string name;
        uint256 price;
    }
    Product[] public productList;
    struct Orders {
        address buyer;
        uint256 amount;
        uint256 price;
        Product product;
    }
    error ThereIsNoEthersInTransaction();
    error YouAreNotAnOwner();
    error InvalidInput();
    error ValueIsNotEnough();

    constructor(address _owner) {
        owner = _owner;
    }

    function setStoreBlance() public payable {
        if (msg.sender != owner) {
            revert YouAreNotAnOwner();
        }
        storeBalance = msg.value;
    }
    function setProduct(string calldata _name, uint256 _price) external {
        if (msg.sender != owner) {
            revert YouAreNotAnOwner();
        }
        if (bytes(_name).length == 0 || _price == 0) {
            revert InvalidInput();
        }
        productList.push(Product({name: _name, price: _price}));
    }

    function sell(uint256 indexOfProdduct) external payable virtual;
    function refundPayment() external payable virtual;
}

contract ZaraStore is PaymentProcessorBase {
    constructor() PaymentProcessorBase(msg.sender) {}

    function sell(uint256 indexOfProdduct) external payable override {
        if (indexOfProdduct >= productList.length) {
            revert InvalidInput();
        }
        if (msg.value < productList[indexOfProdduct].price) {
            revert ValueIsNotEnough();
        }
        Orders memory order = Orders({
            buyer: msg.sender,
            amount: msg.value,
            price: productList[indexOfProdduct].price,
            product: productList[indexOfProdduct]
        });
        productList[indexOfProdduct].price = 0;
    }

    function refundPayment() external payable override {}
}
