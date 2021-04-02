param location string = resourceGroup().location
param vnetName string = 'vnet'
param vnetAddressPrefix string = '10.10.0.0/16'
param subnetName string = 'vmss-sub'
param subnetAddressPrefix string = '10.10.0.0/24'
param nsgName string = 'nsg'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes:[
        vnetAddressPrefix
      ]
    }
    subnets:[
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules:[
      {
        name: 'AllowHTTP'
        properties:{
          priority: 1000
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
        }
      }
    ]
  }
}

output nsgId string = nsg.id
output vnetId string = vnet.id
output subnetId string = '${vnet.id}/subnets/${vnet.properties.subnets[0].name}'