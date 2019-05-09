<#  
.SYNOPSIS  
Onboards all Azure Resource Manager Windows and Linux VMs in the specified Subscriptions into 
OMS management by installing the OS-appropriate agent extension.

.EXAMPLE
.\Onboard-VMsForManagement

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
    [Parameter(HelpMessage="Optional comma-separated list of Resource Group names")]
    [String] $resourceGroupNamesCSVList,
    [Parameter(Mandatory=$true)] 
    [String] $workspaceId,
    [Parameter(Mandatory=$true)] 
    [String] $workspaceKey,
    [Parameter(Mandatory=$false, HelpMessage="Set to True to force association to the specified Log Analytics workspace")]
    [bool] $forceInstall
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

# Get the Resource Group names to onboard.
$isResourceGroups = $false;
$resourceGroupNamesList = @{};
if (!([string]::IsNullOrEmpty($resourceGroupNamesCSVList)))
{
  $isResourceGroups = $true;
  $resourceGroupNamesList = $resourceGroupNamesCSVList.Split(",")
}

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
    if ($isResourceGroups)
    {
      if ($resourceGroupNamesList -Contains $vm.ResourceGroupName -ne "True")
      {
        Write-Output "$($vm.Name) in $($vm.ResourceGroupName) not in list of specified Resource Groups to onboard. Skipping."
        Continue;
      }
    }

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
        Write-Output "$($extensionNameAndTypeValue) extension is already installed for VM $($vm.Name)"
        if (!$forceInstall)
        {
          Write-Output "Skipping VM $($vm.Name)"
          Continue
        }
      }
    }
    catch 
    {
      # Ignore error
    }
  
    # Delay to avoid throttling limits.
    Start-Sleep -s 2

    # Add the agent to the VM.
    $vmId = $vm.Id
    $returnValue = Set-AzureRmVMExtension -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name `
      -Name $extensionNameAndTypeValue -Publisher "Microsoft.EnterpriseCloud.Monitoring" `
      -ExtensionType $extensionNameAndTypeValue -TypeHandlerVersion "1.0" -Location $vm.Location `
      -SettingString "{'workspaceId': '$workspaceId', 'azureResourceId':'$vmId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey'}" 

    if ($null -eq $returnValue) 
    {
        Write-Output ($vm.Name + " did not add extension")
        Write-Error ($vm.Name + " did not add extension") -ErrorAction Continue
    }
    else 
    {
        Write-Output ($vm.Name + " extension has been deployed")
    }
  }
}
