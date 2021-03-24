param location string = resourceGroup().location

@minLength(3)
@maxLength(24)
param storageAcctName string = uniqueString(resourceGroup().id)
param globalRedundancy bool = true

resource stgacct 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAcctName
  location: location
  kind:'StorageV2'
  sku:{
    name: globalRedundancy ?  'Standard_GRS' : 'Standard_LRS' // ternary operator example
    tier: 'Standard'
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAcctName}/default/logs2'
}

output storageId string = stgacct.id
output storageName string = stgacct.name
output blobEndpoint string = stgacct.properties.primaryEndpoints.blob

// az deployment group create -f .\challenge-02.bicep -g iac-fasthack

// PS 7 does not work
// New-AzResourceGroupDeployment -ResourceGroupName iac-fasthack -TemplateFile .\challenge-02.bicep