$name = "AuditVMmDiagnostics"
$displayName = "Audit VM Diagnostics are Enabled"
$policy = ".\definition.json"

# Create policy definition
$definition = New-AzPolicyDefinition -Name $name -DisplayName $displayName -Policy $policy