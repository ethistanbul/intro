pragma solidity ^0.4.18;

contract HelloWorld{
	
	uint value;

	function HelloWorld(){
		value = 1000;
	}

	function setValue(uint256 _value) public {
		value = _value;
	}

	function getValue() public view returns(uint){
		return value;
	}
}