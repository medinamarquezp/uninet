# UNINET (universities network)

This Hyperledger Fabric network consists of the following components:

- 3 peer nodes, whose ledgers use couchdb.
- 1 Raft orderer node.
- All nodes have their own CA.

The genesis block configuration will be given by:

- A block time of 2 seconds.
- A block with a maximum of 10 transactions.
- A block, which, at most, will have 99Mb.

## Instalation instructions

```sh
# Before begin we must set some environment variables in network folder
cd ./network
export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/../config

# Next, we need to execute the following scripts to start the network
. ./start.sh && clearExistingNetworks
. ./start.sh && startCAs
. ./start.sh && registerNodes
. ./start.sh && startNetwork
. ./start.sh && startChannels
```
