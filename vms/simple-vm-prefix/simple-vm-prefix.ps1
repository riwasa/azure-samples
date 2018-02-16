# *****************************************************************************
#
# File:        simple-vm-prefix.ps1
#
# Description: Creates a single Virtual Machine.
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

$resourceGroupName = Read-Host -Prompt "Enter the name of the Resource Group"
$resourceNamePrefix = Read-Host -Prompt "Enter the prefix for Resource names"

# Create the environment.
New-AzureRmResourceGroupDeployment -Name simple-vm -ResourceGroupName $resourceGroupName `
  -TemplateFile "$PSScriptRoot\simple-vm-prefix-azuredeploy.json" `
  -TemplateParameterFile "$PSScriptRoot\simple-vm-prefix-azuredeploy.parameters.json" `
  -resourceNamePrefix $resourceNamePrefix
