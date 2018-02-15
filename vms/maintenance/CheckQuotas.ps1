# Logon to Azure ARM
$Azure = Get-AzureRmEnvironment 'AzureCloud'
$Env = Login-AzureRmAccount -Environment $Azure -Verbose

# Select Subscription
#Select-AzureRmProfile -Profile $Env
$Subscription = (Get-AzureRmSubscription | Out-GridView -Title "Choose a Source Subscription ..." -PassThru)

# Select Subscription Function
Function Subscription {
#Select-AzureRmProfile -Profile $Env
Get-AzureRmSubscription -SubscriptionName $Subscription.SubscriptionName | Select-AzureRmSubscription
}

Function RESTAPI-Auth {
 
# Load ADAL Azure AD Authentication Library Assemblies
Subscription
$adal = "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
$adalforms = "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll"
$null = [System.Reflection.Assembly]::LoadFrom($adal)
$null = [System.Reflection.Assembly]::LoadFrom($adalforms)
 
$adTenant = $Subscription.TenantId
$global:SubscriptionID = $Subscription.SubscriptionId
 
# Client ID for Azure PowerShell
$clientId = "1950a258-227b-4e31-a9cf-717495945fc2"
# Set redirect URI for Azure PowerShell
$redirectUri = "urn:ietf:wg:oauth:2.0:oob"
# Set Resource URI to Azure Service Management API | @marckean
$resourceAppIdURIASM = "https://management.core.windows.net/"
$resourceAppIdURIARM = "https://management.azure.com/"
 
# Authenticate and Acquire Token
 
# Set Authority to Azure AD Tenant
$authority = "https://login.windows.net/$adTenant"
# Create Authentication Context tied to Azure AD Tenant
$authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
# Acquire token
$global:authResultASM = $authContext.AcquireToken($resourceAppIdURIASM, $clientId, $redirectUri, "Auto")
$global:authResultARM = $authContext.AcquireToken($resourceAppIdURIARM, $clientId, $redirectUri, "Auto")
}

Function ARM-VMInfoAPI ($VMName, $RGName) { # to get the source storage key
# Create Authorization Header
$authHeader = $global:authResultARM.CreateAuthorizationHeader()
# Set HTTP request headers to include Authorization header | @marckean
$requestHeader = @{
"x-ms-version" = "2014-10-01"; #'2014-10-01'
"Authorization" = $authHeader
}
$Uri = "https://management.azure.com/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Compute/virtualMachines/{2}?api-version={3}" `
-f $SubscriptionID, $RGName, $VMName, '2017-08-01'
$Global:VMInfo = Invoke-RestMethod -Method Get -Headers $requestheader -Uri $uri
 
}

Subscription
RESTAPI-Auth # To Logon to Rest and get an an auth key
 

 
# Run Rest API call to get the Storage Key
$Name = (Get-AzureRmResource | ? {$_.ResourceType -match 'Microsoft.Compute/virtualMachines'})[0].Name
$ResourceGroupName = (Get-AzureRmResource | ? {$_.ResourceType -match 'Microsoft.Compute/virtualMachines'})[0].ResourceGroupName
ARM-VMInfoAPI $Name $ResourceGroupName
 
# Display the Results
$Global:VMInfo