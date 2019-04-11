# *****************************************************************************
#
# File:        04-CreateStorageAccounts.ps1
#
# Description: Creates Storage Accounts and Blob containers.
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

# Script variables.
$resourceGroupName="Demo-PremiumBlob"
$location="East US"
$standardName="rimdemopbstdlrs"
$premiumName="rimdemopbpremlrs"

# Import the AzureRM.Storage preview module.
# Import-Module AzureRM.Storage -RequiredVersion 6.0.0

# Create a Standard Blob Storage Account.
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $standardName `
    -Location $location -Kind "StorageV2" -SkuName "Standard_LRS"

# Create a Premium Blob Storage Account.
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $premiumName `
    -Location $location -Kind "BlockBlobStorage" -SkuName "Premium_LRS"

# Create a Blob container.
New-AzureRmStorageContainer -ResourceGroupName $resourceGroupName -StorageAccountName $standardName `
    -Name "uploads" -PublicAccess None

Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $standardName

# Create a Blob container.
New-AzureRmStorageContainer -ResourceGroupName $resourceGroupName -StorageAccountName $premiumName `
    -Name "uploads" -PublicAccess None
Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $premiumName

Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $premiumName
