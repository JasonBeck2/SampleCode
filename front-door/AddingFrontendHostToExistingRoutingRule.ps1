$resourceGroupName = "frontdoortest"
$frontFoorName = "jbfrontdoor"
$frontendHostName = "app1.thejbdemo.com"
$httpsRedirectRoutingRuleName = "http-https-redirect"

# Get frontend endpoint ID by hostname
$frontendEndpointId = Get-AzFrontDoorFrontendEndpoint -ResourceGroupName $resourceGroupName -FrontDoorName $frontFoorName | ? { $_.HostName -eq $frontendHostName } | select -ExpandProperty id

# Get front door resource
$fd = Get-AzFrontDoor -ResourceGroupName $resourceGroupName -Name $frontFoorName

# Add the frontend endpoint ID. This change is local and has not been set in Azure.
($fd | select -ExpandProperty RoutingRules | ? { $_.name -eq $httpsRedirectRoutingRuleName }).FrontendEndpointIds.Add($frontendEndpointId)

# Set the front door resource to push the changes in Azure
$fd | Set-AzFrontDoor