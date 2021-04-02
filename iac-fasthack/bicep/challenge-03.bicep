param location string = resourceGroup().location

@minLength(3)
@maxLength(24)
param storageAcctName string = uniqueString(resourceGroup().id)
param containerNames array = [
  'one'
  'two'
  'three'
]

resource stgacct 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: storageAcctName
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for name in containerNames: {
  name: '${stgacct.name}/default/${name}'
}]

output storageId string = stgacct.id
output storageName string = stgacct.name
output blobEndpoint string = stgacct.properties.primaryEndpoints.blob
output containerProps array = [for i in range(0, length(containerNames)): container[i].id]

// az deployment group create -f .\challenge-03.bicep -g iac-fasthack

// PS 7 does not work
// New-AzResourceGroupDeployment -ResourceGroupName iac-fasthack -TemplateFile .\challenge-03.bicep