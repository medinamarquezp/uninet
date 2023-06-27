#!/bin/bash

function createuned() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/uned.universities.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/uned.universities.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-uned --tls.certfiles "${PWD}/organizations/fabric-ca/uned/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uned.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uned.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uned.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uned.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/uned.universities.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-uned --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/uned/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-uned --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/uned/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-uned --id.name unedadmin --id.secret unedadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/uned/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-uned -M "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/msp" --csr.hosts peer0.uned.universities.com --tls.certfiles "${PWD}/organizations/fabric-ca/uned/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uned.universities.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-uned -M "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/tls" --enrollment.profile tls --csr.hosts peer0.uned.universities.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/uned/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/uned.universities.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uned.universities.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/uned.universities.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uned.universities.com/tlsca/tlsca.uned.universities.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/uned.universities.com/ca"
  cp "${PWD}/organizations/peerOrganizations/uned.universities.com/peers/peer0.uned.universities.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/uned.universities.com/ca/ca.uned.universities.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-uned -M "${PWD}/organizations/peerOrganizations/uned.universities.com/users/User1@uned.universities.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/uned/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uned.universities.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uned.universities.com/users/User1@uned.universities.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://unedadmin:unedadminpw@localhost:7054 --caname ca-uned -M "${PWD}/organizations/peerOrganizations/uned.universities.com/users/Admin@uned.universities.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/uned/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uned.universities.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uned.universities.com/users/Admin@uned.universities.com/msp/config.yaml"
}

function createuoc() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/uoc.universities.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/uoc.universities.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-uoc --tls.certfiles "${PWD}/organizations/fabric-ca/uoc/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-uoc.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-uoc.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-uoc.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-uoc.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/uoc.universities.com/msp/config.yaml"

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-uoc --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/uoc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-uoc --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/uoc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-uoc --id.name uocadmin --id.secret uocadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/uoc/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-uoc -M "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/msp" --csr.hosts peer1.uoc.universities.com --tls.certfiles "${PWD}/organizations/fabric-ca/uoc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uoc.universities.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/msp/config.yaml"

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-uoc -M "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/tls" --enrollment.profile tls --csr.hosts peer1.uoc.universities.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/uoc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/uoc.universities.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uoc.universities.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/uoc.universities.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uoc.universities.com/tlsca/tlsca.uoc.universities.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/uoc.universities.com/ca"
  cp "${PWD}/organizations/peerOrganizations/uoc.universities.com/peers/peer1.uoc.universities.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/uoc.universities.com/ca/ca.uoc.universities.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-uoc -M "${PWD}/organizations/peerOrganizations/uoc.universities.com/users/User1@uoc.universities.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/uoc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uoc.universities.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uoc.universities.com/users/User1@uoc.universities.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://uocadmin:uocadminpw@localhost:8054 --caname ca-uoc -M "${PWD}/organizations/peerOrganizations/uoc.universities.com/users/Admin@uoc.universities.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/uoc/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uoc.universities.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uoc.universities.com/users/Admin@uoc.universities.com/msp/config.yaml"
}

function createviu() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/viu.universities.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/viu.universities.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-viu --tls.certfiles "${PWD}/organizations/fabric-ca/viu/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-viu.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-viu.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-viu.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-viu.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/viu.universities.com/msp/config.yaml"

  infoln "Registering peer2"
  set -x
  fabric-ca-client register --caname ca-viu --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/viu/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-viu --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/viu/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-viu --id.name viuadmin --id.secret viuadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/viu/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:10054 --caname ca-viu -M "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/msp" --csr.hosts peer2.viu.universities.com --tls.certfiles "${PWD}/organizations/fabric-ca/viu/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/viu.universities.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/msp/config.yaml"

  infoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:10054 --caname ca-viu -M "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/tls" --enrollment.profile tls --csr.hosts peer2.viu.universities.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/viu/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/viu.universities.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/viu.universities.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/viu.universities.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/viu.universities.com/tlsca/tlsca.viu.universities.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/viu.universities.com/ca"
  cp "${PWD}/organizations/peerOrganizations/viu.universities.com/peers/peer2.viu.universities.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/viu.universities.com/ca/ca.viu.universities.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca-viu -M "${PWD}/organizations/peerOrganizations/viu.universities.com/users/User1@viu.universities.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/viu/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/viu.universities.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/viu.universities.com/users/User1@viu.universities.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://viuadmin:viuadminpw@localhost:10054 --caname ca-viu -M "${PWD}/organizations/peerOrganizations/viu.universities.com/users/Admin@viu.universities.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/viu/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/viu.universities.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/viu.universities.com/users/Admin@viu.universities.com/msp/config.yaml"
}

function createorderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/universities.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/universities.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/universities.com/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/msp" --csr.hosts orderer.universities.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/universities.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls" --enrollment.profile tls --csr.hosts orderer.universities.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/msp/tlscacerts/tlsca.universities.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/universities.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/universities.com/orderers/orderer.universities.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/universities.com/msp/tlscacerts/tlsca.universities.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/universities.com/users/Admin@universities.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/universities.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/universities.com/users/Admin@universities.com/msp/config.yaml"
}
