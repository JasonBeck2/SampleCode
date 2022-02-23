## Running the AzVMRunCommand for a single VM
# $IPsString = "10.0.2.5 10.0.2.6"
# Invoke-AzVMRunCommand -ResourceGroupName ips -VMName vm1 -CommandId 'RunPowerShellScript' -ScriptPath .\updateIPs.ps1 -Parameter @{"IPsString" = $IPsString}
##

param(
    # Param required to be a string for Run Command. String of IPs separated by spaces e.g. "10.0.2.5 10.0.2.6"
    [String]$IPsString
)

# Convert string of IPs to array
$IPs = $IPsString.Split()

foreach ($IP in $IPs) {
    if ($IPs.Indexof($IP) -eq 0) {
        Write-Output "firstIP is" $IP
        $server = hostname
        Write-Output "checking server" $server
        Remove-NetIPAddress -InterfaceIndex (Get-NetAdapter).ifIndex -IPAddress "$IP" -Confirm:$false
        New-NetIPAddress -InterfaceIndex (Get-NetAdapter).ifIndex -IPAddress "$IP" -PrefixLength 24 -DefaultGateway 10.0.2.1
        # Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses $dns
    }
    Else { 
        Write-Output "secondaryIP is" $IP
        New-NetIPAddress -InterfaceIndex (Get-NetAdapter).ifIndex -IPAddress "$IP" -PrefixLength 24 
    }
}
