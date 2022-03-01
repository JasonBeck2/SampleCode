$rgName = 'Migrate-RG'
$projectName = 'MigrateProject'

# Returns a list of ApplianceNames and vmwaresite name
Get-AzResource -ResourceGroupName $rgName -ResourceType 'microsoft.offazure/vmwaresites' | % { Get-AzMigrateSite -ResourceGroupName $rgName -Name $_.Name | Select ApplianceName, Name }

# Get list of servers from a specific appliance by filtering on the vmwaresite and the DisplayName
$vmwareSite = 'vCenter76461site'
$vmName = 'W2K16'
Get-AzMigrateDiscoveredServer -ProjectName $projectName -ResourceGroupName $rgName -DisplayName $vmName | ? { $_.Id.split('/')[8] -eq $vmwareSite }