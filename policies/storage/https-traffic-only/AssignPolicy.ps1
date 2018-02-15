$resourceGroup = Get-AzureRmResourceGroup -Name "Mag-Policy"

$policyDefinition = Get-AzureRmPolicyDefinition -Name "StorageHttpsTrafficOnly"

New-AzureRMPolicyAssignment -Name "Require HTTPS for Storage Accounts" `
    -Scope $resourceGroup.ResourceId -PolicyDefinition $policyDefinition