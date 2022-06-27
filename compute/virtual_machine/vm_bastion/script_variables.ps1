# *****************************************************************************
#
# File:        script-variables.ps1
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

# Resource Group name.
$resourceGroupName = "rim-demo-vnet-and-vm"

# Bastion Host name.
$bastionHostName = "$resourceGroupName-bastion"

# Bastion Host Network Security Group name.
$bastionHostNetworkSecurityGroupName = "$bastionHostName-nsg"

# Bastion Host Public IP Address name.
$bastionHostPublicIpAddressName = "$bastionHostName-pip"

# Network Security Group name.
$networkSecurityGroupName = "$resourceGroupName-nsg"

# Virtual Machine computer name.
$virtualMachineComputerName = "TestVM"

# Virtual Machine name.
$virtualMachineName = "$resourceGroupName-vm"

# Virtual Network name.
$virtualNetworkName = "$resourceGroupName-vnet"

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
