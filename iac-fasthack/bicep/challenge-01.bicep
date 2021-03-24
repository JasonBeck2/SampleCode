param location string = 'westus2'

@minLength(3)
@maxLength(24)
param storageAcctName string = 'jbiac54321'

resource stgacct 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAcctName
  location: location
  kind:'StorageV2'
  sku:{
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

output storageId string = stgacct.id

// build bicep to output ARM template
// bicep build .\challenge-01.bicep

// az deployment group create -f .\challenge-01.bicep -g iac-fasthack

// PS 7 does not work
// New-AzResourceGroupDeployment -ResourceGroupName iac-fasthack -TemplateFile .\challenge-01.bicep