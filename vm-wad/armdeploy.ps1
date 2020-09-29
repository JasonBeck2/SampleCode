#########################################
# PowerShell - Deploy WAD to existing VM
# https://docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostics-extension-windows-install
#########################################

$RgName = "afd-appgw"
$VmName = "web1"
$ConfPath = ".\diagconf.json"

# VM must be running
Set-AzVMDiagnosticsExtension -ResourceGroupName $RgName -VMName $VmName -DiagnosticsConfigurationPath $ConfPath