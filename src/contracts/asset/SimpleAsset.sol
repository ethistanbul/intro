pragma solidity ^0.4.18;

contract SimpleAsset{

	address public owner;
    
    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

	function SimpleAsset(){
		owner = msg.sender;
	}

	function transfer(address newOwner) public onlyOwner{
		owner = newOwner;
	}
}


