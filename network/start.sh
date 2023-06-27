#!/bin/bash

function clearExistingNetworks() {
    # Delete traces of previously created networks
    # 🔥 Caution, the following Docker commands delete all Docker data. You should not run them if you have other containers running that you do not want to delete.
    echo 'Removing all previously existing networks configurations'
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker volume prune
    docker network prune
    rm -rf organizations/peerOrganizations
    rm -rf organizations/ordererOrganizations
    sudo rm -rf organizations/fabric-ca/uned/
    sudo rm -rf organizations/fabric-ca/uoc/
    sudo rm -rf organizations/fabric-ca/viu/
    sudo rm -rf organizations/fabric-ca/ordererOrg/
    rm -rf channel-artifacts/
    mkdir channel-artifacts
}

function startCAs() {
    echo 'Starting CA'
    docker-compose -f ./docker/docker-compose-ca.yaml up -d
}

function registerNodes() {
    echo 'Registering certificates for each node'
    . ./organizations/fabric-ca/registerEnroll.sh && createorderer
    . ./organizations/fabric-ca/registerEnroll.sh && createuned
    . ./organizations/fabric-ca/registerEnroll.sh && createuoc
    . ./organizations/fabric-ca/registerEnroll.sh && createviu
}

function startNetwork() {
    echo 'Starting all network nodes'
    docker-compose -f ./docker/docker-compose-universities.yaml up -d
}

function startChannels() {
    # Orderer node starts and joins recognitions, programs and degrees channels
    echo 'Orderer node starts and joins recognitions, programs and degrees channels'
    export FABRIC_CFG_PATH=${PWD}/configtx
    configtxgen -profile ChannelsGenesis -outputBlock ./channel-artifacts/recognitionschannel.block -channelID recognitionschannel
    configtxgen -profile ChannelsGenesis -outputBlock ./channel-artifacts/programschannel.block -channelID programschannel
    configtxgen -profile ChannelsGenesis -outputBlock ./channel-artifacts/degreeschannel.block -channelID degreeschannel
    export FABRIC_CFG_PATH=${PWD}/../config
    export ORDERER_CA=${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/msp/tlscacerts/tlsca.universities.com-cert.pem
    export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls/server.crt
    export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls/server.key
    osnadmin channel join --channelID recognitionschannel --config-block ./channel-artifacts/recognitionschannel.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
    osnadmin channel join --channelID programschannel --config-block ./channel-artifacts/programschannel.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
    osnadmin channel join --channelID degreeschannel --config-block ./channel-artifacts/degreeschannel.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

    # uned node joins recognitions, programs and degrees channels
    echo 'uned node joins recognitions, programs and degrees channels'
    export CORE_PEER_TLS_ENABLED=true
    export PEER0_uned_CA=${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/tls/ca.crt
    export CORE_PEER_LOCALMSPID="unedMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_uned_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uned.universities.com/users/Admin@uned.universities.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    peer channel join -b ./channel-artifacts/recognitionschannel.block
    peer channel join -b ./channel-artifacts/programschannel.block
    peer channel join -b ./channel-artifacts/degreeschannel.block

    # uoc node joins recognitions, programs and degrees channels
    echo 'uoc node joins recognitions, programs and degrees channels'
    export PEER1_uoc_CA=${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/tls/ca.crt
    export CORE_PEER_LOCALMSPID="uocMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_uoc_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uoc.universities.com/users/Admin@uoc.universities.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    peer channel join -b ./channel-artifacts/recognitionschannel.block
    peer channel join -b ./channel-artifacts/programschannel.block
    peer channel join -b ./channel-artifacts/degreeschannel.block

    # viu node joins programs and degrees channels
    echo 'viu node joins programs and degrees channels'
    export PEER2_viu_CA=${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/tls/ca.crt
    export CORE_PEER_LOCALMSPID="viuMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER2_viu_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/viu.universities.com/users/Admin@viu.universities.com/msp
    export CORE_PEER_ADDRESS=localhost:2051
    peer channel join -b ./channel-artifacts/programschannel.block
    peer channel join -b ./channel-artifacts/degreeschannel.block
}