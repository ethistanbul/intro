pragma solidity ^0.4.18;

contract AssetContainer2{

	mapping(bytes32=>mapping(address=>uint)) assetOwners;
	mapping(bytes32=>bool) inCirculation;
	uint nominator = 10*9;

	function AssetContainer2(){
	
	}

	function issue(bytes32 asset, address receiver) public returns(bool){
		
		require(!inCirculation[asset]);
		assetOwners[asset][receiver] = nominator;
		inCirculation[asset] = true;
		return true;
	}

	function transfer(bytes32 asset, address receiver, uint value) public returns(bool) {
		
		require(inCirculation[asset] = true);
		require(value <= assetOwners[asset][msg.sender]);
		assetOwners[asset][msg.sender] -= value;
		assetOwners[asset][receiver] += value; 
		return true;
	}

	function balanceOf(bytes32 asset,address owner) public view returns (uint){

		return assetOwners[asset][owner];
	}

}
