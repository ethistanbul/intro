pragma solidity ^0.4.18;


contract BasicToken {
	function totalSupply() public view returns (uint256);
	function balanceOf(address who) public view returns (uint256);
	function transfer(address to, uint256 value) public returns (bool);
	function transfer(address to, uint256 value, bytes32 data) public returns (bool);
	function transferToContract(address to, uint256 value, bytes32 data) public returns (bool);
	event Transfer(address indexed from, address indexed to, bytes32 indexed data, uint256 value);
}