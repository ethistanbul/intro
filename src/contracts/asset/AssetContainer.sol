pragma solidity ^0.4.18;

contract AssetContainer{

	mapping(bytes32=>address) assetOwners;
    
	function AssetContainer(){
	
	}

	function issue(bytes32 asset, address owner) public returns(bool){

		require(assetOwners[asset] != address(0));
		assetOwners[asset] = owner;
		return true;
	}

	function transfer(bytes32 asset, address receiver)  public returns(bool) {

		require(assetOwners[asset] == msg.sender);
		assetOwners[asset] = receiver;
		return true;
	}

	function ownerOf(bytes32 asset) public view returns (address){
		return assetOwners[asset];
	}

}
