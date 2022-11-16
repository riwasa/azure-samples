# *****************************************************************************
#
# File:        script_variables.ps1
#
# Description: Sets variables used in other scripts.
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

# Azure region.
$location = "eastus2"
$locationName = "East US 2"

# Resource Group name.
$resourceGroupName = "rim-man-us-logicase"
$resourceGroupRawName = "rimmanuslogicase"

# App Service Environment name.
$appServiceEnvironmentName = "$($resourceGroupName)-ase"

# App Service Environment Virtual Network subnet name.
# Note if you change this value, it must also be changed in virtual_network\virtual_network.parameters.json.
$appServiceEnvironmentSubnetName = 'ase'

# Logic App name.
$logicAppName = "$($resourceGroupName)-logic"

# Logic App Application Insights Component name.
$logicAppApplicationInsightsComponentName = "$($logicAppName)-appi"

# Logic App Application Insights Component Log Analytics Workspace name.
$logicAppApplicationInsightsLogAnalyticsWorkspaceName = "$($logicAppApplicationInsightsComponentName)-law"

# Logic App App Service Plan name.
$logicAppAppServicePlanName = "$($logicAppName)-asp"

# Logic App Storage Account name.
$logicAppStorageAccountName = "$($resourceGroupRawName)logicstr"

# Virtual Network name.
$virtualNetworkName = "$($resourceGroupName)-vnet"

# Function to ask the user to enter a password for use in a resource.
function Get-Password {
  param (
    $message
  )

  $password = Read-Host "Please enter a password to use for $message" -MaskInput
  $confirmPassword = Read-Host "Please re-enter the password to confirm" -MaskInput

  if ($password -ceq $confirmPassword) {
      $password
   } else {
      Write-Host "ERROR: Passwords do not match"
      exit
  }
}
