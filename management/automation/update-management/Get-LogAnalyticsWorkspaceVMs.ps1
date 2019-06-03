# *****************************************************************************
#
# File:        Get-LogAnalyticsWorkspaceVMs.ps1
#
# Description: Iterates through all Log Analytics Workspaces in the current
#              Subscription, and lists the VMs reporting to each.
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

# Get all Log Analytics Workspaces in the current Subscription.
$workspaces = Get-AzureRmOperationalInsightsWorkspace

foreach ($workspace in $workspaces)
{
  Write-Output "--------------------"
  Write-Output "Workspace: $($workspace.Name)"
  Write-Output "Resource Group: $($workspace.ResourceGroupName)"
  Write-Output "Location: $($workspace.Location)"
  Write-Output "Workspace ID: $($workspace.CustomerId)"

  $query = "Heartbeat | summarize LastCall = max(TimeGenerated) by Computer"

  $queryResults = Invoke-AzureRmOperationalInsightsQuery -WorkspaceId $workspace.CustomerId -Query $query
  $queryResults.Results
}
