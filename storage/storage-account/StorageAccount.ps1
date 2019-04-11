# *****************************************************************************
#
# File:        StorageAccount.ps1
#
# Description: Creates a Storage Account.
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

# Prompt for the name of the Resource Group.
$resourceGroupName = Read-Host 'Please enter the name of the existing Resource Group to use'

# Create the Storage Account.
$deployment = New-AzureRmResourceGroupDeployment -Name Storage `
	-ResourceGroupName $resourceGroupName `
    -TemplateFile "$PSScriptRoot\StorageAccount-azuredeploy.json" `
	-TemplateParameterFile "$PSScriptRoot\StorageAccount-azuredeploy.parameters.json"

$storageAccountName = $deployment.Outputs.storageAccountName.value

Write-Host "Storage Account Name:" $storageAccountName

# Get the Storage Account and set the storage context for subsequent commands.
$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName 
$storageContext = $storageAccount.Context
