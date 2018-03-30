pragma solidity ^0.4.18;


contract Depositable{
	function depositToken(address depositor,uint value) returns(bool);
	function getTokenBalance(address tokenContract,address addr) constant returns(uint);
}

contract TokenVault is Depositable{

	mapping(address=>mapping(address=>uint)) tokenBalances;

	event TokenDeposit(address indexed tokenContract,address indexed depositor,uint value);
	event TokenTransfered(address indexed tokenContract,address indexed sender,address indexed receiver,uint value);
	event TokenSent(address indexed tokenContract,address indexed sender,address indexed receiver,uint value);
	event SellOrder(address indexed tokenContract, uint amount, uint saleFor);


	function TokenVault() payable {

	}

	// Only from token contract
	function depositToken(address depositor,uint value) returns(bool){
		tokenBalances[msg.sender][depositor] += value;
		TokenDeposit(msg.sender,depositor,value);
		return true;
	}

	function getTokenBalance(address tokenContract,address addr) constant returns(uint){
		return tokenBalances[tokenContract][addr];
	}

	function transferToken(address tokenContractAddress,address receiver,uint value){
		require(tokenBalances[tokenContractAddress][receiver] >= value);
		tokenBalances[tokenContractAddress][msg.sender] -= value;
		tokenBalances[tokenContractAddress][receiver] += value;
		TokenTransfered(tokenContractAddress,msg.sender,receiver,value);
	}

	function sendToken(address tokenContractAddress,address receiver,uint value){
		require(tokenBalances[tokenContractAddress][receiver] >= value);
		BasicToken tokenContract = BasicToken(tokenContractAddress);
		if(tokenContract.transfer(receiver,value)){
			tokenBalances[tokenContractAddress][msg.sender] -= value;
		}
		TokenSent(tokenContractAddress,msg.sender,receiver,value);
	}

	function putSellOrder(address tokenContract, uint amount, uint saleFor){


	}

	function revokeSellOrder(){


	}

	function buy() payable {


	}
}


contract BasicToken {
	function totalSupply() public view returns (uint256);
	function balanceOf(address who) public view returns (uint256);
	function transfer(address to, uint256 value) public returns (bool);
	function transfer(address to, uint256 value, bytes32 data) public returns (bool);
	function transferToContract(address to, uint256 value, bytes32 data) public returns (bool);
	event Transfer(address indexed from, address indexed to, bytes32 indexed data, uint256 value);
}