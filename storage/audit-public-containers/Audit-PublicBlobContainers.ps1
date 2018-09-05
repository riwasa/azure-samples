# *****************************************************************************
#
# File:        Audit-PublicBlobContainers.ps1
#
# Description: Checks for public read-only blob containers in Storage Account
#              in Subscriptions accessible to the user.
#
#              The user must have the RBAC permission
#              Microsoft.Storage/storageAccounts/listKeys/action to audit
#              a Storage Account successfully.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
# *****************************************************************************

# Log in for ARM.
$armConnectionName = "AzureRunAsConnection"
$armConnection = Get-AutomationConnection -Name $armConnectionName

if ($armConnection -eq $null)
{
    throw "Could not retrieve connection asset: $armConnectionName. Check that this asset exists in the Automation account."
}

$subscriptionId = $armConnection.SubscriptionId

Login-AzureRmAccount -ServicePrincipal -Tenant $armConnection.TenantID `
    -ApplicationId $armConnection.ApplicationID `
    -CertificateThumbprint $armConnection.CertificateThumbprint 

# Log in for ASM.
$asmConnectionName = "AzureClassicRunAsConnection"
$asmConnection = Get-AutomationConnection -Name $asmConnectionName

if ($asmConnection -eq $null)
{
    throw "Could not retrieve connection asset: $asmConnectionName. Check that this asset exists in the Automation account."
}

$asmCertificate = Get-AutomationCertificate -Name $asmConnection.CertificateAssetName
  
Set-AzureSubscription `
    -SubscriptionName $asmConnection.SubscriptionName `
    -SubscriptionId $asmConnection.SubscriptionId `
    -Certificate $asmCertificate

Select-AzureSubscription -SubscriptionId $asmConnection.SubscriptionId

# Get all resources in the Subscription.
$resources = Get-AzureRmResource

foreach ($resource in $resources)
{
    if ($resource.ResourceType -eq "Microsoft.Storage/storageAccounts")
    {
        # The resource is an ARM Storage Account.
        $context = (Get-AzureRmStorageAccount -Name $resource.Name -ResourceGroupName $resource.ResourceGroupName).Context
            
        # Get the containers in the Storage Account.
        $containers = Get-AzureStorageContainer -Context $context
            
        foreach ($container in $containers)
        {
            if ($container.PublicAccess -ne "Off")
            {
                # The container has public access configured either at the Blob or the Container level.
                Write-Output "$($subscriptionId), ARM, $($context.StorageAccountName), $($container.Name), $($container.PublicAccess)"
            }
        }
    }
    elseif ($resource.ResourceType -eq "Microsoft.ClassicStorage/storageAccounts")
    {
        # The resource is an ASM (Classic) Storage Account.
        $context = (Get-AzureStorageAccount -StorageAccountName $resource.Name).Context

        # Get the containers in the Storage Account.
        $containers = Get-AzureStorageContainer -Context $context

        foreach ($container in $containers)
        {
            if ($container.PublicAccess -ne "Off")
            {
                # The container has public access configured either at the Blob or the Container level.
                Write-Output "$($subscriptionId), ASM, $($context.StorageAccountName), $($container.Name), $($container.PublicAccess)"
            }
        }
    }
}