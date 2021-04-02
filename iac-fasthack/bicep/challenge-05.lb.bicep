param location string = resourceGroup().location
param pipName string = 'vmss-elb-pip'
param lbName string = 'elb'
param lbFrontEndName string = 'FrontEnd'
param lbBackEndName string = 'BackEnd'
param lbHTTPRule string = 'http'
param lbProbeName string = 'tcp80probe'

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: pipName
  location: location
  sku:{
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource lb 'Microsoft.Network/loadBalancers@2020-06-01' = {
  name: lbName
  location: location
  sku: {
    name:'Standard'
  }
  properties:{
   frontendIPConfigurations:[
     {
       name: lbFrontEndName
       properties: {
         publicIPAddress:{
           id: pip.id
         }
       }
     }
   ]
   loadBalancingRules:[
     {
       name:lbHTTPRule
       properties: {
        frontendIPConfiguration:{
          id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, lbFrontEndName)
        }
        frontendPort: 80
        backendPort: 80
        protocol: 'Tcp'
        enableFloatingIP: false
        probe: {
          id:resourceId('Microsoft.Network/loadBalancers/probes', lbName, lbProbeName)
        }
        backendAddressPool: {
          id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, lbBackEndName)
        }
       }
     }
   ]
   probes:[
     {
       name: lbProbeName
       properties: {
         protocol: 'Tcp'
         port: 80
         intervalInSeconds: 5
         numberOfProbes: 2
       }
     }
   ]
   backendAddressPools:[
     {
       name: lbBackEndName
     }
   ]
  }
}

output lbId string = lb.id
output backendPoolName string = lb.properties.backendAddressPools[0].name