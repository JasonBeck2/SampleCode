
$creds = Get-Credential -Message "Add the Log Analytics workspace for the password. The username can be anything."
$workspaceID = ""

$RgName = ""
$VMName = ""
$Location = ""
$FileUri = "https://jbsa2.blob.core.windows.net/scripts/mmaconfig.ps1"
$Run = ".\mmaconfig.ps1"
$workspaceKey = $creds.GetNetworkCredential().Password
$Argument = "$workspaceID $workspaceKey"

Set-AzVMCustomScriptExtension -ResourceGroup $RgName -VMName $VMName -Location $Location -FileUri $FileUri -Name "CSE-MMAMultihome" -Run $Run -Argument $Argument -SecureExecution