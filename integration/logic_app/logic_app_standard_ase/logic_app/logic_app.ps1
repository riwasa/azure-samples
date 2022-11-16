# *****************************************************************************
#
# File:        logic_app.ps1
#
# Description: Creates a Logic App.
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

# Create a Logic App.
Write-Host "Creating a Logic App"

az deployment group create `
  --name "logic_app" `
  --resource-group "$resourceGroupName" `
  --template-file "$PSScriptRoot\logic_app.bicep" `
  --parameters "$PSScriptRoot\logic_app.parameters.json" `
  --parameters applicationInsightsComponentName="$logicAppApplicationInsightsComponentName" `
               appServiceEnvironmentName="$appServiceEnvironmentName" `
               appServicePlanName="$logicAppAppServicePlanName" `
               location="$location" `
               logicAppName="$logicAppName" `
               storageAccountName="$logicAppStorageAccountName"
