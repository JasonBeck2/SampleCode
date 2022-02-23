// param location string = 'westus2'
param location2 string = 'westcentralus'

// param vnet1name string = 'sharedservices-wu2'
// param vnet1addr string = '172.17.0.0/16'
// param vnet1subname string = 'app'
// param vnet1fw string = '172.17.0.0/24'
// param vnet1subaddr string = '172.17.1.0/24'

param vnet6name string = 'sharedservices-wc'
param vnet6addr string = '10.11.0.0/16'
param vnet6subname string = 'app'
param vnet6fw string = '10.11.0.0/24'
param vnet6subaddr string = '10.11.1.0/24'

// param vnet2name string = 'spoke1-wu2'
// param vnet2addr string = '172.18.0.0/16'
// param vnet2subname string = 'app'
// param vnet2subaddr string = '172.18.0.0/24'

// param vnet3name string = 'spoke2-wu2'
// param vnet3addr string = '172.19.0.0/16'
// param vnet3subname string = 'app'
// param vnet3subaddr string = '172.19.0.0/24'

param vnet4name string = 'spoke3-wc'
param vnet4addr string = '10.12.0.0/16'
param vnet4subname string = 'app'
param vnet4subaddr string = '10.12.0.0/24'

param vnet5name string = 'spoke4-wc'
param vnet5addr string = '10.13.0.0/16'
param vnet5subname string = 'app'
param vnet5subaddr string = '10.13.0.0/24'

// resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' = {
//   name: vnet1name
//   location: location
//   properties: {
//     addressSpace: {
//       addressPrefixes: [
//         vnet1addr
//       ]
//     }
//     subnets:[
//       {
//         name: 'AzureFirewallSubnet'
//         properties: {
//           addressPrefix: vnet1fw
//         }
//       }
//       {
//         name: vnet1subname
//         properties: {
//           addressPrefix: vnet1subaddr
//         }
//       }
//     ]
//   }
// }

resource vnet6 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnet6name
  location: location2
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet6addr
      ]
    }
    subnets:[
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: vnet6fw
        }
      }
      {
        name: vnet6subname
        properties: {
          addressPrefix: vnet6subaddr
        }
      }
    ]
  }
}

// resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' = {
//   name: vnet2name
//   location: location
//   properties: {
//     addressSpace: {
//       addressPrefixes: [
//         vnet2addr
//       ]
//     }
//     subnets:[
//       {
//         name: vnet2subname
//         properties: {
//           addressPrefix: vnet2subaddr
//         }
//       }
//     ]
//   }
// }

// resource vnet3 'Microsoft.Network/virtualNetworks@2021-02-01' = {
//   name: vnet3name
//   location: location
//   properties: {
//     addressSpace: {
//       addressPrefixes: [
//         vnet3addr
//       ]
//     }
//     subnets:[
//       {
//         name: vnet3subname
//         properties: {
//           addressPrefix: vnet3subaddr
//         }
//       }
//     ]
//   }
// }

resource vnet4 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnet4name
  location: location2
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

resource vnet5 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnet5name
  location: location2
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet5addr
      ]
    }
    subnets:[
      {
        name: vnet5subname
        properties: {
          addressPrefix: vnet5subaddr
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
