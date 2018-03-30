pragma solidity ^0.4.18;

contract Depositable{
	function depositToken(address depositor,uint value) returns(bool);
	function getTokenBalance(address tokenContract,address addr) constant returns(uint);
}