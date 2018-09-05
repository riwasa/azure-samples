# *****************************************************************************
#
# File:        SetupActivityLogExportToEventHub.ps1
#
# Description: Sets up exports of the Activity Log to an Event Hub.
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

# Script variables.
$resourceGroupName = "<resource group name your event hub belongs to>"
$eventHubNamespace = "<event hub namespace>"

$subscriptionId = (Get-AzureRmContext).Subscription.Id

# Check if there is already a log profile.
$logProfile = Get-AzureRmLogProfile

if ($logProfile -ne $null)
{
    $logProfileName = $logProfile.Name

    Write-Host "Log profile '$logProfileName' already exists"

    $confirm = Read-Host -Prompt "Type 'yes' to remove the existing profile; otherwise type 'no'"

    if ($confirm -ne 'yes')
    {
        exit
    }

    Write-Host "Removing the existing profile"
    Remove-AzureRmLogProfile -Name $logProfileName
}

# Settings needed for the new log profile
$logProfileName = "default"

# Get all Azure public regions and add on the 'global' location.
$locations = (Get-AzureRmLocation).Location
$locations += "global"

# Build the service bus rule id.
$serviceBusRuleId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.EventHub/namespaces/$eventHubNamespace/authorizationrules/RootManageSharedAccessKey"

# Add the log profile.
Add-AzureRmLogProfile -Name $logProfileName -Location $locations -ServiceBusRuleId $serviceBusRuleId
