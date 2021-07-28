# *****************************************************************************
#
# File:        application-insights-template-ps.ps1
#
# Description: Creates an Application Insights Component backed by a Log
#              Analytics Workspace.
#
#              This script uses Azure PowerShell and an ARM template.
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

# Set script variables.
$applicationInsightsName = "rim-demo-appi"
$logAnalyticsName = "rim-demo-appi-law"
$location = "canadacentral"
$resourceGroupName = "rim-demo"

# Create an Application Insights component.
New-AzResourceGroupDeployment `
  -Name "application-insights" `
  -ResourceGroupName $resourceGroupName `
  -TemplateFile "$PSScriptRoot\application-insights.azuredeploy.json" `
  -TemplateParameterFile "$PSScriptRoot\application-insights.azuredeploy.parameters.json" `
  -applicationInsightsName $applicationInsightsName `
  -logAnalyticsName $logAnalyticsName `
  -location $location