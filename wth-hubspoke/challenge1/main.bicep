param location string = resourceGroup().location
param vnet1Name string = 'hub'
param vnet2Name string = 'spoke1'
param vnet3Name string = 'spoke2'
param vnet4Name string = 'onprem'

var vnet1Config = {
  addressSpacePrefix: '10.0.0.0/16'
  subnetName: 'vms'
  subnetPrefix: '10.0.10.0/24'
  gatewayPrefix: '10.0.0.0/24'
  gatewayName: 'vpn-vng'
  appgwName: 'appgw'
  appgwPrefix: '10.0.2.0/24'
  bastionPrefix: '10.0.4.0/24'
  asn: 65501
  gatewayPublicIPName: 'vpn-pip'
  connectionName: 'onprem'
  lngName: 'onprem-lng'
  sharedkey: '1234567890'
}
var vnet2Config = {
  addressSpacePrefix: '10.1.0.0/16'
  subnetName: 'vms'
  subnetPrefix: '10.1.10.0/24'
  appserviceName: 'appservice'
  appservicePrefix: '10.1.20.0/24'
  privateendpointPrefix: '10.1.30.0/24'
}
var vnet3Config = {
  addressSpacePrefix: '10.2.0.0/16'
  subnetName: 'vms'
  subnetPrefix: '10.2.10.0/24'
}
var vnet4Config = {
  addressSpacePrefix: '172.16.0.0/16'
  subnetName: 'nva'
  subnetPrefix: '172.16.1.0/24'
  bastionPrefix: '172.16.0.0/24'
}

@allowed([
  'Standard'
  'HighPerformance'
  'VpnGw1'
  'VpnGw2'
  'VpnGw3'
])
param gatewaySku string = 'VpnGw1'

resource vnet1 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnet1Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet1Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnet1Config.subnetName
        properties: {
          addressPrefix: vnet1Config.subnetPrefix
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: vnet1Config.gatewayPrefix
        
        }
      }
      {
        name: vnet1Config.appgwName
        properties: {
          addressPrefix: vnet1Config.appgwPrefix
        
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: vnet1Config.bastionPrefix
        
        }
      }
    ]
  }
}

resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet1
  name: '${vnet1Name}-${vnet2Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet2.id
    }
  }
}

resource VnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet1
  name: '${vnet1Name}-${vnet3Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet3.id
    }
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnet2Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet2Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnet2Config.subnetName
        properties: {
          addressPrefix: vnet2Config.subnetPrefix
        }
      }
      {
        name: vnet2Config.appserviceName
        properties: {
          addressPrefix: vnet2Config.appservicePrefix
        }
      }
      {
        name: 'privateendpoints'
        properties: {
          addressPrefix: vnet2Config.privateendpointPrefix
        }
      }
    ]
  }
}

resource vnetPeering3 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet2
  name: '${vnet2Name}-${vnet1Name}'
  // dependsOn:[
  //   vnet1Gateway
  // ]
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
    remoteVirtualNetwork: {
      id: vnet1.id
    }
  }
}

resource vnet3 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnet3Name
  location: location
  // dependsOn:[
  //   vnet1Gateway
  // ]
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet3Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnet3Config.subnetName
        properties: {
          addressPrefix: vnet3Config.subnetPrefix
        }
      }
    ]
  }
}

resource vnetPeering4 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet3
  name: '${vnet3Name}-${vnet1Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
    remoteVirtualNetwork: {
      id: vnet1.id
    }
  }
}

// resource vnet4 'Microsoft.Network/virtualNetworks@2020-05-01' = {
//   name: vnet4Name
//   location: location
//   properties: {
//     addressSpace: {
//       addressPrefixes: [
//         vnet4Config.addressSpacePrefix
//       ]
//     }
//     subnets: [
//       {
//         name: vnet4Config.subnetName
//         properties: {
//           addressPrefix: vnet4Config.subnetPrefix
//         }
//       }
//       {
//         name: 'AzureBastionSubnet'
//         properties: {
//           addressPrefix: vnet4Config.bastionPrefix
        
//         }
//       }
//     ]
//   }
// }

resource gw1pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: vnet1Config.gatewayPublicIPName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// resource vnet1Gateway 'Microsoft.Network/virtualNetworkGateways@2020-06-01' = {
//   name: vnet1Config.gatewayName
//   location: location
//   properties: {
//     ipConfigurations: [
//       {
//         name: 'vnet1GatewayConfig'
//         properties: {
//           privateIPAllocationMethod: 'Dynamic'
//           subnet: {
//             id: resourceId('Microsoft.Network/virtualNetworks/subnets',vnet1.name , 'GatewaySubnet')
//           }
//           publicIPAddress: {
//             id: gw1pip.id
//           }
//         }
//       }
//     ]
//     gatewayType: 'Vpn'
//     sku: {
//       name: gatewaySku
//       tier: gatewaySku
//     }
//     vpnType: 'RouteBased'
//     enableBgp: true
//     bgpSettings: {
//       asn: vnet1Config.asn
//     }
//   }
// }

// resource vnet1Connection 'Microsoft.Network/connections@2021-03-01' = {
//   name: vnet1Config.connectionName
//   location: location
//   properties: {
//     connectionType: 'IPsec'
//     virtualNetworkGateway1: {
//       id: vnet1Gateway.id
//     }
//     virtualNetworkGateway2: {
//       id: onpremLNG.id
//     }
//     connectionProtocol: 'IKEv2'
//     routingWeight: 0
//     enableBgp: true
//     sharedKey: vnet1Config.sharedkey
//   }
// }

// resource onpremLNG 'Microsoft.Network/localNetworkGateways@2021-03-01' = {
//   name: vnet1Config.lngName
//   location: location
// }
