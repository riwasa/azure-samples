# *****************************************************************************
#
# File:        virtual_network.ps1
#
# Description: Creates a Virtual Network and Bastion Host.
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

# Create a Virtual Network
Write-Host "Creating a Virtual Network"

az deployment group create `
  --name "virtual-network" `
  --resource-group "$resourceGroupName" `
  --template-file "$PSScriptRoot\virtual_network.bicep" `
  --parameters "$PSScriptRoot\virtual_network.parameters.json" `
  --parameters appServiceEnvironmentName="$appServiceEnvironmentName" `
               appServiceEnvironmentSubnetName="$appServiceEnvironmentSubnetName" `
               location="$location" `
               virtualNetworkName="$virtualNetworkName"