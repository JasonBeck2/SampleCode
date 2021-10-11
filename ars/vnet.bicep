param location string = 'westus2'

param vnet1name string = 'hub'
param vnet1addr string = '10.10.0.0/16'
param vnet1subname string = 'nva'
param vnet1gw string = '10.10.0.0/24'
param vnet1ars string = '10.10.1.0/24'
param vnet1subaddr string = '10.10.2.0/24'

param vnet2name string = 'onprem'
param vnet2addr string = '172.16.0.0/16'
param vnet2subname string = 'app'
param vnet2gw string = '172.16.0.0/24'
param vnet2subaddr string = '172.16.1.0/24'

param vnet3name string = 'spoke1'
param vnet3addr string = '10.20.0.0/16'
param vnet3subname string = 'app'
param vnet3subaddr string = '10.20.0.0/24'

param vnet4name string = 'spoke2'
param vnet4addr string = '10.30.0.0/16'
param vnet4subname string = 'app'
param vnet4subaddr string = '10.30.0.0/24'

resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnet1name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet1addr
      ]
    }
    subnets:[
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: vnet1gw
        }
      }
      {
        name: 'RouteServerSubnet'
        properties: {
          addressPrefix: vnet1ars
        }
      }
      {
        name: vnet1subname
        properties: {
          addressPrefix: vnet1subaddr
        }
      }
    ]
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnet2name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet2addr
      ]
    }
    subnets:[
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: vnet2gw
        }
      }
      {
        name: vnet2subname
        properties: {
          addressPrefix: vnet2subaddr
        }
      }
    ]
  }
}

resource vnet3 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnet3name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet3addr
      ]
    }
    subnets:[
      {
        name: vnet3subname
        properties: {
          addressPrefix: vnet3subaddr
        }
      }
    ]
  }
}

resource vnet4 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnet4name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet4addr
      ]
    }
    subnets:[
      {
        name: vnet4subname
        properties: {
          addressPrefix: vnet4subaddr
        }
      }
    ]
  }
}

// deploy route server in PS and CLI
// $subid = az network vnet subnet show --name RouteServerSubnet --resource-group ars-testing --vnet-name hub --query id -o tsv
// az network public-ip create --name rs-pip --resource-group ars-testing --version ipv4 --sku Standard
// az network routeserver create --name ars --resource-group ars-testing --hosted-subnet $subid --public-ip-address rs-pip

// Show route server
// az network routeserver show --name ars --resource-group ars-testing

// Create Ubuntu VM and install quagga
// config script here https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.network/route-server-quagga/scripts/quaggadeploy.sh

// Peer with NVA
// az network routeserver peering create --name nva --peer-ip 10.10.2.4 --peer-asn 65001 --routeserver ars -g ars-testing
