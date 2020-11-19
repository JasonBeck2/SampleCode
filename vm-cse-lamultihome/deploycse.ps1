
# This very basic script will run a custom script extension to register all running VMs in the resource group with the specified Log Anaylytics workspace.
# This can be used when multihoming a VM to mulitple workspaces.
# Assumes you have already logged into Azure (connect-azaccount)

# Add the worksapce ID and resource group name
$workspaceID = ""
$RgName = ""

# No changes required below this line
$creds = Get-Credential -Message "Add the Log Analytics workspace for the password. The username can be anything but not empty."
$FileUri = "https://raw.githubusercontent.com/JasonBeck2/SampleCode/master/vm-cse-lamultihome/mmaconfig.ps1"
$Run = ".\mmaconfig.ps1"
$workspaceKey = $creds.GetNetworkCredential().Password
$Argument = "$workspaceID $workspaceKey"
$VMs = Get-AzVM -ResourceGroupName $RgName

foreach($VM in $VMs){
    # Each iteration of the VMs will take several minutes to complete

    $VMStatus = Get-AzVM -ResourceGroupName $RgName -Name $VM.Name -Status
    if($VMStatus.Statuses[1].Code -eq "PowerState/running"){
        Write-Output "$($VM.Name) - Running custom script extension to register to the specified Log Analytics workspace"
        Set-AzVMCustomScriptExtension -ResourceGroup $RgName -VMName $VM.Name -Location $VM.Location -FileUri $FileUri -Name "CSE-MMAMultihome" -Run $Run -Argument $Argument -SecureExecution
    }
    else{
        Write-Output "$($VM.Name) is not running. Skipping..."
    }
}