#########################################
# ARM Template
#########################################

$RgName = "AutomationDemo"
$TemplateFile = ".\azuredeploy.json"
$ParamFile = ".\parameters.json"

Test-AzResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $TemplateFile -TemplateParameterFile $ParamFile

New-AzResourceGroupDeployment -Name "VMDeployment" -ResourceGroupName $RgName -TemplateFile $TemplateFile -TemplateParameterFile $ParamFile -Debug


#########################################
# Azure PowerShell
#########################################

$Location = "west central us"
$RgName = "AutomationDemo"
$VnetName = "vnet"
$SubnetName = "web"
$VmName = "web2"
$NicName = $VmName+"-nic"
$SecurePassword = ConvertTo-SecureString '##########' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("demouser", $SecurePassword)

# Create NIC
$Vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $RgName
$Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $Vnet
$nic = New-AzNetworkInterface -Name $NicName -ResourceGroupName $RgName -SubnetId $Subnet.Id -Location $Location

# TODO: Create disk

# Create VM conf
$VmConfig = New-AzVMConfig -VMName $VmName -VMSize "Standard_B2s" | `
Set-AzVMOperatingSystem -Windows -ComputerName $VmName -Credential $Cred | `
Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2019-Datacenter" -Version "latest" | `
Add-AzVMNetworkInterface -Id $nic.Id

# Create VM
New-AzVM -VM $VmConfig -ResourceGroupName $RgName -Location $Location