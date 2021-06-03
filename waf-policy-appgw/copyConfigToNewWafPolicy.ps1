# This script will copy the managed ruleset, custom rules, and exclusions from an original WAF policy and apply it to another specified WAF policy
# Warning: This will override existing configurations on the 'new' WAF policy specified below. Use with caution and only for testing purposes.

# original WAF policy and resource group
$rgName = "rgname"
$wafPolicyName = "waf-old"

# new WAF policy to receive the copied configuration. Any existing configuration on this WAF policy will be lost.
$newRgName = "rgname2"
$newWafPolicyName = "waf-new"

$wafPolicy = Get-AzApplicationGatewayFirewallPolicy -Name $wafPolicyName -ResourceGroupName $rgName
$newWafPolicy = Get-AzApplicationGatewayFirewallPolicy -Name $newWafPolicyName -ResourceGroupName $newRgName

$newWafPolicy.ManagedRules.Exclusions = $wafPolicy.ManagedRules.Exclusions
$newWafPolicy.ManagedRules.ManagedRuleSets = $wafPolicy.ManagedRules.ManagedRuleSets
$newWafPolicy.CustomRules = $wafPolicy.CustomRules

$newWafPolicy | Set-AzApplicationGatewayFirewallPolicy