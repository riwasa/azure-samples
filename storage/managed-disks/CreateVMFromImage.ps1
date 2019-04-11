# *****************************************************************************
#
# File:        CreateVMFromImage.ps1
#
# Description: Creates a Virtual Machine from a Managed Image.
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

# Name of the Resource Group.
$resourceGroupName = "Sample-MD"

# Get the local admin password to use.
$password = Read-Host 'Please enter a password to use for the local admin account on the VM' -AsSecureString

# Create the environment.
New-AzureRmResourceGroupDeployment -Name ManagedImageVM -ResourceGroupName $resourceGroupName `
  -TemplateFile "$PSScriptRoot\CreateVMFromImage-azuredeploy.json" `
  -TemplateParameterFile "$PSScriptRoot\CreateVMFromImage-azuredeploy.parameters.json" `
  -adminPassword $password
