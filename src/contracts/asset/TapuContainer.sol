pragma solidity ^0.4.18;

/*
rinkeby addr
"0xa068ab96d5a2d664352bf604fb7089d137890bcd"

abi
[{"constant": true, "inputs": [], "name": "denetleyici", "outputs": [{"name": "", "type": "address"} ], "payable": false, "stateMutability": "view", "type": "function"}, {"constant": false, "inputs": [{"name": "newTapu", "type": "bytes32"}, {"name": "_owner", "type": "address"} ], "name": "issue", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function"}, {"constant": false, "inputs": [{"name": "tapu", "type": "bytes32"} ], "name": "killTapu", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function"}, {"constant": false, "inputs": [{"name": "tapu", "type": "bytes32"}, {"name": "receiver", "type": "address"} ], "name": "transfer", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function"}, {"constant": true, "inputs": [{"name": "tapu", "type": "bytes32"} ], "name": "ownerOf", "outputs": [{"name": "", "type": "address"} ], "payable": false, "stateMutability": "view", "type": "function"}, {"constant": false, "inputs": [{"name": "newDenetleyici", "type": "address"} ], "name": "changeDenetleyici", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function"}, {"inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor"}, {"anonymous": false, "inputs": [{"indexed": false, "name": "whichTapu", "type": "bytes32"}, {"indexed": false, "name": "from", "type": "address"}, {"indexed": false, "name": "to", "type": "address"} ], "name": "Transfered", "type": "event"} ]
*/

contract TapuContainer{
    
	address public denetleyici;
	mapping(bytes32=>address) owners;
	
	event Transfered(bytes32 whichTapu, address from, address to);

    modifier onlyDenetleyici(){
        if(msg.sender != denetleyici){
            throw;
        }
        _;
    }

	function TapuContainer(){

		denetleyici = msg.sender;
	}

	function issue(bytes32 newTapu,address _owner) onlyDenetleyici{

        if(owners[newTapu] != address(0)){
            throw;
        }
        
        owners[newTapu] = _owner;
        
	}

	function transfer(bytes32 tapu,address receiver){
	    
	    if(owners[tapu] != msg.sender){
	        throw;
	    }
	    
	    owners[tapu] = receiver;
	    Transfered(tapu,msg.sender,receiver);
	}
	
	function killTapu(bytes32 tapu) onlyDenetleyici{

        owners[tapu] = address(0);
	}
	
	function ownerOf(bytes32 tapu) constant returns(address){
	    
	    return owners[tapu];
	}
	
	function changeDenetleyici(address newDenetleyici) onlyDenetleyici{
	    
	    denetleyici = newDenetleyici;
	}
}
