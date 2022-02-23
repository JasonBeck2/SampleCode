# This is for testing purposes only
# Change the following variables based on the environment.
$interfaceIndex = (Get-NetAdapter).ifIndex
$primaryIP = '10.0.2.5'
$secondaryIP = '10.0.2.6'
$gateway = '10.0.2.1'
$prefix = 24
$dns = @('168.63.129.16')

# Remove existing IP learned from DHCP
Remove-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress $primaryIP -Confirm:$false

# Configure primary IP and DNS
New-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress $primaryIP -PrefixLength $prefix -DefaultGateway $gateway 
Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses $dns

# Configure secondary IPs
New-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress $secondaryIP -PrefixLength $prefix