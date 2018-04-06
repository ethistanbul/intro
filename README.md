# Helper Sheet

## Simple Linux Commands

#### Go to home directory
`cd /home/<USERNAME>`

#### Change directory
`cd xyz`
`cd xyz/abc`

#### List files in the current directory
`ls -al`

#### Print working(current) directory
`pwd`

#### Display contents of a file
`cat /path/to/<FILENAME>`

## Geth
#### Run a node
`geth --datadir /home/<USERNAME>/chain`

#### Attaching running node at different terminal window
`geth attach /home/<USERNAME>/chain/geth.ipc`

## You are in geth console now!

#### Resources

github.com/ethereum/wiki/wiki/White-Paper
github.com/ethereum/wiki/wiki/JSON-RPC


#### Creating new account
`personal.newAccount('<PASSPHRASE>')`

#### Listing accounts
`eth.accounts`

#### Viewing address of an account by its index
`eth.accounts[0]`

#### Setting default account
`eth.defaultAccount = eth.accounts[0]`

#### Unlocking an account by its passphrase
`personal.unlockAccount(eth.defaultAccount,'<PASSPHRASE>',<DURATION>)`
*PASSPHRASE="Your passphrase"*
*DURATION=999999*

#### Viewing balance of an account 
`eth.getBalance(<ADDRESS>)`

or

`eth.getBalance(eth.defaultAccount)`

or

`eth.getBalance(eth.accounts[0])`

#### Sending ether
```
receiver = <RECEIVER_ADDRESS>
sender = eth.defaultAccount
amount = web3.toWei(1,'ether')
info = web3.fromUtf8(“xyz abc some arbitrary data”)
tx = {from: sender, to: receiver, value: value: amount, data: info}
eth.sendTransaction(tx) // Returns tx hash like 0x15a7b90c...
```

#### Viewing transaction details by its hash
`txhash = 0x15a7b90c...`

`eth.getTransaction(txhash)`

or

`eth.getTransactionReceipt(txhash)`

#### Viewing block details by its hash or static keywords
`eth.getBlock("latest")`

or

```
blockHash = "0x2bdf0d7f9cef27c7ee2a8e5ad04b"
eth.getBlockByHash(blockHash)
```


## Private Development Network
#### Init private node
`geth --datadir /home/<USERNAME>/.privatechain genesis.json init`

#### Start private node
`geth --datadir /home/<USERNAME>/.privatechain --nodiscover --rpc`
