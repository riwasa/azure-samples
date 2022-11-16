# *****************************************************************************
#
# File:        application_insights.ps1
#
# Description: Creates an Application Insights Component for a Logic App.
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

# Get script variables.
. $PSScriptRoot\..\script_variables.ps1

# Create an Application Insights Component.
Write-Host "Creating an Application Insights Component"

az deployment group create `
  --name "logic-app-application-insights" `
  --resource-group "$resourceGroupName" `
  --template-file "$PSScriptRoot\application_insights.bicep" `
  --parameters "$PSScriptRoot\application_insights.parameters.json" `
  --parameters applicationInsightsName="$logicAppApplicationInsightsComponentName" `
               logAnalyticsName="$logicAppApplicationInsightsLogAnalyticsWorkspaceName" `
               location="$location"