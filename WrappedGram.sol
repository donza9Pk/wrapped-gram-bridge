// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Wrapped Gram Token (WGRAM)
 * @dev Open-source smart contract for Wrapped Gram to facilitate decentralized cross-chain asset transfers.
 * Built for core ecosystem infrastructure and public goods identity verification.
 */

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view return uint256;
    function balanceOf(address account) external view return uint256;
    function transfer(address to, uint256 value) external return (bool);
    function allowance(address owner, address spender) external view return uint256;
    function approve(address spender, uint256 value) external return (bool);
    function transferFrom(address from, address to, uint256 value) external return (bool);
}

contract WrappedGram is IERC20 {
    string public constant name = "Wrapped Gram";
    string public constant symbol = "WGRAM";
    uint8 public constant decimals = 18;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    uint256 private _totalSupply;
    address public owner;

    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    modifier onlyOwner() {
        require(msg.sender == owner, "WGRAM: Caller is not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function totalSupply() external view override return uint256 {
        return _totalSupply;
    }

    function balanceOf(address account) external view override return uint256 {
        return _balances[account];
    }

    function transfer(address to, uint256 value) external override return (bool) {
        require(to != address(0), "WGRAM: Transfer to the zero address");
        require(_balances[msg.sender] >= value, "WGRAM: Insufficient balance");

        _balances[msg.sender] -= value;
        _balances[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function allowance(address ownerAddress, address spender) external view override return (uint256) {
        return _allowances[ownerAddress][spender];
    }

    function approve(address spender, uint256 value) external override return (bool) {
        require(spender != address(0), "WGRAM: Approve to the zero address");

        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external override return (bool) {
        require(from != address(0), "WGRAM: Transfer from the zero address");
        require(to != address(0), "WGRAM: Transfer to the zero address");
        require(_balances[from] >= value, "WGRAM: Insufficient balance");
        require(_allowances[from][msg.sender] >= value, "WGRAM: Transfer amount exceeds allowance");

        _balances[from] -= value;
        _balances[to] += value;
        _allowances[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    function depositBridge(address account, uint256 amount) external onlyOwner {
        require(account != address(0), "WGRAM: Mint to the zero address");
        
        _totalSupply += amount;
        _balances[account] += amount;
        
        emit Deposit(account, amount);
        emit Transfer(address(0), account, amount);
    }

    function withdrawBridge(address account, uint256 amount) external onlyOwner {
        require(account != address(0), "WGRAM: Burn from the zero address");
        require(_balances[account] >= amount, "WGRAM: Burn amount exceeds balance");

        _balances[account] -= amount;
        _totalSupply -= amount;

        emit Withdrawal(account, amount);
        emit Transfer(account, address(0), amount);
    }
}
