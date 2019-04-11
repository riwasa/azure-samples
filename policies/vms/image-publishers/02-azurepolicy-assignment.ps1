# *****************************************************************************
#
# File:        02-azurepolicy-assignment.ps1
#
# Description: Assigns a policy to allow only specific image publishers for
#              Windows Server and Linux VMs.
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

# Get the name of the Resource Group that will be the scope of the assignment
$resourceGroupName = Read-Host -Prompt "Enter the name of the Resource Group"

# Get a reference to the Resource Group.
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName

if ($null -eq $resourceGroup) {
  Write-Host "ERROR: Resource Group '$resourceGroupName' does not exist"
  exit
}

# Get a reference to the Policy.
$policyName = "allow-vm-image-publishers"
$definition = Get-AzPolicyDefinition -Name $policyName

if ($null -eq $definition) {
  Write-Host "ERROR: Policy '$policyName' does not exist"
  exit
}

# Define the allowed image publishers.
$allowedPublishers = "MicrosoftWindowsServer", "Canonical", "RedHat"

# Assign the Policy to the Resource Group.
New-AzPolicyAssignment -Name "allow-vm-image-publishers-windows-linux" `
  -DisplayName "Allow specific image publishers for Windows Server and Linux" `
  -Description "This policy allows only specific image publishers for Windows Server and Linux VMs." `
  -Scope $resourceGroup.ResourceId -PolicyDefinition $definition `
  -listOfAllowedImagePublishers $allowedPublishers