<#  
.SYNOPSIS  
Enables Update Management for all Azure Resource Manager Windows and Linux VMs in the specified Subscriptions.

.EXAMPLE
.\Enable-UpdateManagement

.NOTES
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

AUTHOR: Azure Automation Team
LASTEDIT: 2019.05.03
#>

param 
(
    [Parameter(Mandatory=$true, HelpMessage="Comma-separated list of Subscription ids")] 
    [String] $subscriptionIdsCSVList,
    [Parameter(Mandatory=$true)]
    [String] $logAnalyticsResourceGroupName,
    [Parameter(Mandatory=$true)]
    [String] $logAnalyticsName
)

# Authenticate to Azure.
try 
{
  Write-Output "Logging in to Azure"
  
  $servicePrincipalConnection = Get-AutomationConnection -Name "AzureRunAsConnection"
  
  Add-AzureRmAccount `
    -ServicePrincipal `
    -TenantId $servicePrincipalConnection.TenantId `
    -ApplicationId $servicePrincipalConnection.ApplicationId `
    -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
}
catch 
{
  if (!$servicePrincipalConnection)
  {
    throw "Connection AzureRunAsConnection not found"
  }
  else 
  {
    throw $_.Exception
  }
}

# Get the Subscription ids to onboard.
$subscriptionIdsList = $subscriptionIdsCSVList.Split(",")
$subscriptionNamesList = @{};

$workspace = Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName $logAnalyticsResourceGroupName `
    -Name $logAnalyticsName

$savedGroups = Get-AzureRmOperationalInsightsSavedSearch -ResourceGroupName $workspace.ResourceGroupName `
    -WorkspaceName $workspace.Name

$solutionGroup = $savedGroups.Value | Where-Object {$_.Id -match "MicrosoftDefaultComputerGroup" -and $_.Properties.Category -eq 'Updates'}                                          

$newQuery = $solutionGroup.Properties.Query
$queryUpdated = $False

Write-Output "Old query:"
Write-Output $newQuery

foreach ($subscriptionId in $subscriptionIdsList)
{
  # Get the Subscription to verify the RunAs account has access.
  $subscription = Get-AzureRmSubscription -SubscriptionId $subscriptionId

  if ($null -eq $subscription)
  {
    Write-Output "Cannot get Subscription for id $($subscriptionId). Ensure the RunAs account has Contributor access on the Subscription"
    Continue
  }

  # Switch the context to the Subscription.
  $subscriptionInfo = Select-AzureRmSubscription -SubscriptionId $subscriptionId

  if ($null -ne $subscriptionInfo)
  {
    $subscriptionNamesList.Add($subscriptionInfo.Subscription.SubscriptionId, $subscriptionInfo.Subscription.SubscriptionName)
  }

  # Get a list of ARM VMs in the Subscription.
  $vms = Get-AzureRmVM | Where { $_.StorageProfile.OSDisk.OSType -eq "Windows" -or  $_.StorageProfile.OSDisk.OSType -eq "Linux" }

  foreach ($vm in $vms) 
  {
    $vmName = $vm.Name

    $extensionNameAndTypeValue = 'MicrosoftMonitoringAgent'
        
    if ($vm.StorageProfile.OSDisk.OSType -eq "Linux") 
    {
      $extensionNameAndTypeValue = 'OmsAgentForLinux'	
    }
  
    # Check if the agent is already installed.
    try
    {    
      $vme = Get-AzureRmVMExtension -ExtensionName $extensionNameAndTypeValue `
        -ResourceGroup $vm.ResourceGroupName -VMName $vm.Name -ErrorAction 'SilentlyContinue'
              
      if ($null -ne $vme)
      {     
        if (!($newQuery -match $vmName))
        {
          # VM has been onboarded to Log Analytics. Add it to the list of VMs to be monitored.
          $queryUpdated = $True
          $newQuery = $newQuery.Replace('(',"(`"$vmName`", ")
        }    
      }
      else {
        Write-Output "Skipping VM $($vm.Name)"
        Continue        
      }
    }
    catch 
    {
      # Ignore error
    }
  }
}

if ($queryUpdated)
{
  Write-Output $NewQuery

  $computerGroupQueryTemplateLinkUri = "https://wcusonboardingtemplate.blob.core.windows.net/onboardingtemplate/ArmTemplate/updateKQLScopeQueryV2.json"                                       

  # Add all of the parameters.
  $queryDeploymentParams = @{}
  $queryDeploymentParams.Add("location", $workspace.Location)
  $queryDeploymentParams.Add("id", "/" + $solutionGroup.Id)
  $queryDeploymentParams.Add("resourceName", ($workspace.Name + "/Updates|" + "MicrosoftDefaultComputerGroup").ToLower())
  $queryDeploymentParams.Add("category", "Updates")
  $queryDeploymentParams.Add("displayName", "MicrosoftDefaultComputerGroup")
  $queryDeploymentParams.Add("query", $newQuery)
  $queryDeploymentParams.Add("functionAlias", "Updates__MicrosoftDefaultComputerGroup")
  $queryDeploymentParams.Add("etag", $solutionGroup.ETag)

  # Create a deployment name.
  $deploymentName = "AutomationControl-PS-" + (Get-Date).ToFileTimeUtc()

  $subscriptionContext = Set-AzureRmContext -SubscriptionId $servicePrincipalConnection.SubscriptionId 

  Write-Output "Updating query"

  New-AzureRmResourceGroupDeployment -ResourceGroupName $logAnalyticsResourceGroupName `
    -TemplateUri $computerGroupQueryTemplateLinkUri -Name $deploymentName `
    -TemplateParameterObject $queryDeploymentParams `
    -AzureRmContext $subscriptionContext | Write-Verbose
}
else 
{
  Write-Output "No VMs to enable"
}
