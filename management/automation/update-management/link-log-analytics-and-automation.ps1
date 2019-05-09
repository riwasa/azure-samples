# *****************************************************************************
#
# File:        link-log-analytics-and-automation.ps1
#
# Description: Links an Automation Account with a Log Analytics Workspace.
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

$resourceGroupName = "<resource-group-for-log-analytics-workspace"
$logAnalyticsWorkspaceName = "name-of-log-analytics-workspace"
$automationAccountName = "name-of-automation-account"

New-AzureRmResourceGroupDeployment -Name link-log-auto -ResourceGroupName $resourceGroupName `
  -TemplateFile "$PSScriptRoot\link-log-analytics-and-automation-azuredeploy.json" `
  -logAnalyticsWorkspaceName $logAnalyticsWorkspaceName -automationAccountName $automationAccountName
