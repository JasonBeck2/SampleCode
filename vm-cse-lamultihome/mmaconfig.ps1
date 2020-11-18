param (
    [string] $workspsaceID,
    [string] $workspaceKey
)

$mma = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
$mma.AddCloudWorkspace($workspsaceID, $workspaceKey)
$mma.ReloadConfiguration()