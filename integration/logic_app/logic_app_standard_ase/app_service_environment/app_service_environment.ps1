# *****************************************************************************
#
# File:        app_service_environment.ps1
#
# Description: Creates an App Service Environment.
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

# Create an App Service Environment.
Write-Host "Creating an App Service Environment"

az deployment group create `
  --name "app-service-environment" `
  --resource-group "$resourceGroupName" `
  --template-file "$PSScriptRoot\app_service_environment.bicep" `
  --parameters "$PSScriptRoot\app_service_environment.parameters.json" `
  --parameters appServiceEnvironmentName="$appServiceEnvironmentName" `
               location="$location" `
               subnetName="$appServiceEnvironmentSubnetName" `
               virtualNetworkName="$virtualNetworkName"