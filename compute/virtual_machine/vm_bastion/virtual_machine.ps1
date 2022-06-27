# *****************************************************************************
#
# File:        virtual_machine.ps1
#
# Description: Creates a Virtual Machine.
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
. $PSScriptRoot\script_variables.ps1

# Get the administrator login password.
$adminUsername = Read-Host "Please enter the administrator username"

# Get the administrator login password.
$adminPassword = Get-Password "the administrator"

# Create a Virtual Machine.
Write-Host "Creating a Virtual Machine"

az deployment group create `
  --name "virtual_machine" `
  --resource-group "$resourceGroupName" `
  --template-file "$PSScriptRoot\virtual_machine.bicep" `
  --parameters "$PSScriptRoot\virtual_machine.parameters.json" `
  --parameters adminPassword="$adminPassword" `
               adminUsername="$adminUsername" `
               location="$location" `
               virtualMachineComputerName="$virtualMachineComputerName" `
               virtualMachineName="$virtualMachineName" `
               virtualNetworkName="$virtualNetworkName"
