$vaultName = '' # ASR vault name
$rgName = '' # resource group name which contains the ASR vault (same as Azure Migrate project resource group)

$vault = Get-AzRecoveryServicesVault -Name $vaultName -ResourceGroupName $rgName
Set-ASRVaultContext -Vault $vault | Out-Null
$fabrics = Get-AzRecoveryServicesAsrFabric

$startTime = [DateTime]::Now.Add([TimeSpan]::FromDays(-1)) # Expects UTC time.
# $startTime = [DateTime]::Now.Add([TimeSpan]::FromHours(-20)) # Expects UTC time. Past day if based in Eastern Daylight Time

$events = @() # the array events will contain all events in Azure Migrate: Server Migration for a given project
foreach ($fabric in $fabrics) {
    $asrEvents = Get-AzRecoveryServicesAsrEvent -FabricId $fabric.ID -StartTime $startTime
    foreach ($asrEvent in $asrEvents) {
        $events += ([PSCustomObject]@{
                EventName      = $asrEvent.Description
                EventType      = $asrEvent.EventType
                EventCode      = $asrEvent.EventCode
                Severity       = $asrEvent.Severity
                Source         = $asrEvent.AffectedObjectFriendlyName
                Time           = $asrEvent.TimeOfOccurence
                ErrorId        = $asrEvent.HealthErrors.ErrorCode
                ErrorMessage   = $asrEvent.HealthErrors.ErrorMessage
                PossibleCauses = $asrEvent.HealthErrors.PossibleCauses
                Recommendation = $asrEvent.HealthErrors.Recommendation
                # Id = $asrEvent.Id
            })
    }
}