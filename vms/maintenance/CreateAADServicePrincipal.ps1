$password = ConvertTo-SecureString "Aremai2569!!" -AsPlainText -Force
$sp = New-AzureRmADServicePrincipal -DisplayName "RIM-PSREST" -Password $password
#Sleep 20
#New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $sp.ApplicationId
