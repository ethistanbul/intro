amepragma solidity ^0.4.18;

//import "../asset/AssetContainer.sol";

contract Auction{

	struct Bid{
		address owner;
		address caller;
		uint256 value;
		uint256 deadline;
	}

	event Start(bytes32 indexed asset,uint256 value,uint256 deadline);
	event BidFor(bytes32 indexed asset, address indexed caller, uint256 indexed value);
	event Finalized(bytes32 indexed asset, address indexed winner);

	function Auction(address _container) payable public {
		addrContainer = _container;
	}

	address addrContainer;
	mapping(bytes32=>Bid) highestBids;

	function startAuction(bytes32 asset, uint256 value, uint256 deadline) public notExist(asset) returns(bool){
		
		require(deadline > now);
		require(value>0);
		Bid memory bid = Bid(msg.sender,address(0),value,deadline);
		highestBids[asset] = bid;
		Start(asset,value,deadline);
		return true;
	}

	function bidFor(bytes32 asset) exist(asset) public payable returns(bool){

		Bid storage bid = highestBids[asset];
		require(bid.deadline > now);
		require(msg.value > bid.value);

		if(bid.caller != address(0)){
			require(bid.caller.send(bid.value));
		}

		bid.caller = msg.sender;
		bid.value = msg.value;
		BidFor(asset,msg.sender,msg.value);
		return true;
	}

	function finalizeAuction(bytes32 asset) exist(asset) public returns(bool){

		Bid storage bid = highestBids[asset];
		require(bid.deadline < now);
		require(bid.owner.send(bid.value));
		AssetContainer container = AssetContainer(addrContainer);
		container.issue(asset,bid.caller);
		Finalized(asset,bid.owner);
		return true;
	}

	function getBidFor(bytes32 asset) public view returns(address,address,uint256,uint256) {

		Bid memory bid = highestBids[asset];
		return(bid.owner,bid.caller,bid.value,bid.deadline);
	}


	modifier notExist(bytes32 asset){
		require(highestBids[asset].owner == address(0));
		_;
	}

	modifier exist(bytes32 asset){
		require(highestBids[asset].owner != address(0));
		_;
	}
}

contract AssetContainer{

	mapping(bytes32=>address) assetOwners;
    event Issued(bytes32 indexed asset, address indexed sender, address indexed receiver);
    event Transfered(bytes32 indexed asset, address indexed sender, address indexed receiver);

	function AssetContainer(){
	
	}

	function issue(bytes32 asset, address owner) public returns(bool){

		require(assetOwners[asset] == address(0));
		assetOwners[asset] = owner;
		Issued(asset,msg.sender,owner);
		return true;
	}

	function transfer(bytes32 asset, address receiver)  public returns(bool) {

		require(assetOwners[asset] == msg.sender);
		assetOwners[asset] = receiver;
		Issued(asset,msg.sender,receiver);
		return true;
	}

	function ownerOf(bytes32 asset) public view returns (address){
		return assetOwners[asset];
	}

}


/*

var _container = "0xfecf7f835f994627bd1277a7be7b46f3c3fe8bf9" ;
var auctionContract = web3.eth.contract([{"constant":false,"inputs":[{"name":"asset","type":"bytes32"}],"name":"bidFor","outputs":[{"name":"","type":"bool"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[{"name":"asset","type":"bytes32"}],"name":"finalizeAuction","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"asset","type":"bytes32"}],"name":"getBidFor","outputs":[{"name":"","type":"address"},{"name":"","type":"address"},{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"asset","type":"bytes32"},{"name":"value","type":"uint256"},{"name":"deadline","type":"uint256"}],"name":"startAuction","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"_container","type":"address"}],"payable":true,"stateMutability":"payable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"asset","type":"bytes32"},{"indexed":false,"name":"value","type":"uint256"},{"indexed":false,"name":"deadline","type":"uint256"}],"name":"Start","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"asset","type":"bytes32"},{"indexed":true,"name":"caller","type":"address"},{"indexed":true,"name":"value","type":"uint256"}],"name":"BidFor","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"asset","type":"bytes32"},{"indexed":true,"name":"winner","type":"address"}],"name":"Finalized","type":"event"}]);
var auction = auctionContract.new(
   _container,
   {
     from: web3.eth.accounts[0], 
     data: '0x6060604052604051602080610aab83398101604052808051906020019091905050806000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050610a3b806100706000396000f300606060405260043610610062576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680632ded225314610067578063983b94fb1461009b578063cee0228f146100da578063d135175314610182575b600080fd5b6100816004808035600019169060200190919050506101d3565b604051808215151515815260200191505060405180910390f35b34156100a657600080fd5b6100c06004808035600019169060200190919050506103f5565b604051808215151515815260200191505060405180910390f35b34156100e557600080fd5b6100ff60048080356000191690602001909190505061069b565b604051808573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200183815260200182815260200194505050505060405180910390f35b341561018d57600080fd5b6101b96004808035600019169060200190919080359060200190919080359060200190919050506107b6565b604051808215151515815260200191505060405180910390f35b60008082600073ffffffffffffffffffffffffffffffffffffffff1660016000836000191660001916815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff161415151561025157600080fd5b600160008560001916600019168152602001908152602001600020915042826003015411151561028057600080fd5b81600201543411151561029257600080fd5b600073ffffffffffffffffffffffffffffffffffffffff168260010160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16141515610355578160010160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc83600201549081150290604051600060405180830381858888f19350505050151561035457600080fd5b5b338260010160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550348260020181905550343373ffffffffffffffffffffffffffffffffffffffff1685600019167f63eb4e18b2e34d6bd772daa3f5b4b03cf2c4ccd581dccbce2df6defb9d1dead460405160405180910390a4600192505050919050565b600080600083600073ffffffffffffffffffffffffffffffffffffffff1660016000836000191660001916815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff161415151561047557600080fd5b60016000866000191660001916815260200190815260200160002092504283600301541015156104a457600080fd5b8260000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc84600201549081150290604051600060405180830381858888f19350505050151561050c57600080fd5b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1691508173ffffffffffffffffffffffffffffffffffffffff16631dc4869c868560010160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff166000604051602001526040518363ffffffff167c01000000000000000000000000000000000000000000000000000000000281526004018083600019166000191681526020018273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200192505050602060405180830381600087803b151561060757600080fd5b6102c65a03f1151561061857600080fd5b50505060405180519050508260000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1685600019167fc8132d2d8f69f82e237e4e759636ff4aac1c63b07c86550256d131a90612f12e60405160405180910390a360019350505050919050565b6000806000806106a96109ba565b600160008760001916600019168152602001908152602001600020608060405190810160405290816000820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020016001820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200160028201548152602001600382015481525050905080600001518160200151826040015183606001519450945094509450509193509193565b60006107c06109ba565b84600073ffffffffffffffffffffffffffffffffffffffff1660016000836000191660001916815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614151561083a57600080fd5b428411151561084857600080fd5b60008511151561085757600080fd5b6080604051908101604052803373ffffffffffffffffffffffffffffffffffffffff168152602001600073ffffffffffffffffffffffffffffffffffffffff1681526020018681526020018581525091508160016000886000191660001916815260200190815260200160002060008201518160000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060208201518160010160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550604082015181600201556060820151816003015590505085600019167fb6994f8dc23b30b9a925841716947c7ca3d07dad7f6301c9730b5702cd8a894b8686604051808381526020018281526020019250505060405180910390a26001925050509392505050565b608060405190810160405280600073ffffffffffffffffffffffffffffffffffffffff168152602001600073ffffffffffffffffffffffffffffffffffffffff168152602001600081526020016000815250905600a165627a7a72305820461f290ced5b5f7ccefa84f387f347f31832d46370ec8086c7ca52cc552778250029', 
     gas: '4700000'
   }, function (e, contract){
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
 })
*/
