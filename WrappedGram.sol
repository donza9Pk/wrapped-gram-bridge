// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract WrappedGram {
    string public constant name = "Wrapped Gram";
    string public constant symbol = "WGRAM";
    uint8 public constant decimals = 18;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    address public owner;
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18;
    mapping(bytes32 => bool) public processed;
    address public feeCollector;
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    modifier onlyOwner(){ require(msg.sender==owner, "Not owner"); _; }
    constructor(){ owner = msg.sender; feeCollector = msg.sender; }
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner!=address(0)); emit OwnershipTransferred(owner,newOwner); owner=newOwner;
    }
    function totalSupply() external view returns(uint256){return _totalSupply;}
    function balanceOf(address a) external view returns(uint256){return _balances[a];}
    function allowance(address o, address s) external view returns(uint256){return _allowances[o][s];}
    function transfer(address to, uint256 v) external returns(bool){
        require(to!=address(0) && _balances[msg.sender]>=v); _balances[msg.sender]-=v; _balances[to]+=v; emit Transfer(msg.sender,to,v); return true;
    }
    function approve(address s, uint256 v) external returns(bool){
        require(s!=address(0)); _allowances[msg.sender][s]=v; emit Approval(msg.sender,s,v); return true;
    }
    function transferFrom(address f, address t, uint256 v) external returns(bool){
        require(f!=address(0) && t!=address(0) && _balances[f]>=v && _allowances[f][msg.sender]>=v);
        _balances[f]-=v; _balances[t]+=v; _allowances[f][msg.sender]-=v; emit Transfer(f,t,v); return true;
    }
    function depositBridge(address account, uint256 amount, bytes32 gramTxHash) external onlyOwner {
        require(account!=address(0) &&!processed[gramTxHash] && _totalSupply+amount<=MAX_SUPPLY);
        processed[gramTxHash]=true; _totalSupply+=amount; _balances[account]+=amount;
        emit Deposit(account,amount); emit Transfer(address(0),account,amount);
    }
    function withdrawBridge(address account, uint256 amount, bytes32 gramTxHash) external onlyOwner {
        require(account!=address(0) && _balances[account]>=amount &&!processed[gramTxHash]);
        processed[gramTxHash]=true; _balances[account]-=amount; _totalSupply-=amount;
        emit Withdrawal(account,amount); emit Transfer(account,address(0),amount);
    }
}
