// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract Asset {
    address public owner;
    string public symbol;
    string public name;
    uint256 public initialSupply;
    mapping(address => uint256) public balances;

    error EmptyNameNotAllowed();
    error EmptySymbolNotAllowed();
    error ZeroInitialSupplyNotAllowed();
    error NotOwner();
    error InsufficientSupply();

    constructor(
        string memory _symbol,
        string memory _name,
        uint256 _initialSupply
    ) {
        if (bytes(_symbol).length == 0) revert EmptySymbolNotAllowed();
        if (bytes(_name).length == 0) revert EmptyNameNotAllowed();
        if (_initialSupply == 0) revert ZeroInitialSupplyNotAllowed();
        owner = msg.sender;
        symbol = _symbol;
        name = _name;
        initialSupply = _initialSupply;
    }

    function reduceSupply(address _to, uint256 _amount) public {
        if (msg.sender != owner) revert NotOwner();
        if (_amount > initialSupply) revert InsufficientSupply();
        initialSupply -= _amount;
        balances[_to] += _amount;
    }
}

contract AssetFactory {
    mapping(string => Asset) public assetsBySymbol;
    error SymbolDuplicationNotAllowed();
    error TokenDoesNotExist();
    error NotEnoughTokens();
    error YouAreNotAnOwner();

    function createAsset(
        string memory _symbol,
        string memory _name,
        uint256 _totalSupply
    ) public returns (address) {
        if (address(assetsBySymbol[_symbol]) != address(0)) {
            revert SymbolDuplicationNotAllowed();
        }
        Asset asset = new Asset(_symbol, _name, _totalSupply);
        assetsBySymbol[_symbol] = asset;

        return address(asset);
    }

    function transferToken(
        address _to,
        string memory _symbol,
        uint256 _amount
    ) public {
        if (address(assetsBySymbol[_symbol]) == address(0)) {
            revert TokenDoesNotExist();
        }

        Asset asset = assetsBySymbol[_symbol];
    }
}
