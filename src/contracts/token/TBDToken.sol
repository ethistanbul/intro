pragma solidity ^0.4.18;

import "./BasicToken.sol";

contract TBDToken is BasicToken{

    mapping(address => uint256) balances;
    uint256 totalSupply_;

    uint8 public decimals;
    string public symbol;             
    string public version = '1.0';  

    function ERC20Token() {
        totalSupply_ = 10**9;
        balances[msg.sender] = totalSupply_;
        decimals = 1;
        symbol = "TBD";
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    /* Standart */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        Transfer(msg.sender, _to, bytes32(0), _value);
        return true;
    }


    /* With additional data*/
    function transfer(address _to, uint256 _value, bytes32 data) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        Transfer(msg.sender, _to, data, _value);
        return true;
    }

    /* To depositable contract*/
    function transferToContract(address _to, uint256 _value, bytes32 data) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        Depositable depositable = Depositable(_to);
        depositable.depositToken(msg.sender, _value);
        Transfer(msg.sender, _to, data, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}

contract Depositable{
    function depositToken(address depositor,uint value) returns(bool);
    function getTokenBalance(address tokenContract,address addr) constant returns(uint);
}