param location string = resourceGroup().location
param vmssName string = 'vmss'
param vmssSku string = 'Standard_B2s'
param instanceCount int = 2
param adminUsername string
@secure()
param adminPassword string
param nsgId string
param subnetId string
param lbId string
param bePoolName string
param vmssCseName string = 'install-apache'
param cseScriptBlock string

var nicName = '${vmssName}-nic'
var ipConf = '${vmssName}-ipconf1'
var lbBePool = '${lbId}/backendAddressPools/${bePoolName}'
var imageRef = {
  publisher: 'Canonical'
  offer: 'UbuntuServer'
  sku: '18.04-LTS'
  version: 'latest'
}

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2020-06-01' = {
  name: vmssName
  location: location
  sku: {
    name: vmssSku
    tier: 'Standard'
    capacity: instanceCount
  }
  properties: {
    overprovision: false
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadWrite'
        }
        imageReference: imageRef
      }
      osProfile:{
        computerNamePrefix: vmssName
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: nicName
            properties: {
              primary: true
              networkSecurityGroup:{
                id: nsgId
              }
              ipConfigurations: [
                {
                  name: ipConf
                  properties: {
                    subnet:{
                      id: subnetId
                    }
                    loadBalancerBackendAddressPools:[
                      {
                        id: lbBePool
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
      extensionProfile:{
        extensions:[
          {
            name: vmssCseName
            properties: {
              publisher: 'Microsoft.Azure.Extensions'
              type: 'CustomScript'
              typeHandlerVersion: '2.1'
              autoUpgradeMinorVersion: true
              protectedSettings: {
                script: base64(cseScriptBlock)
              }
            }
          }
        ]
      }
    }
  }
}