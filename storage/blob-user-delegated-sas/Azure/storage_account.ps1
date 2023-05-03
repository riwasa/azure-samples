# *****************************************************************************
#
# File:        storage_account.ps1
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

# Set script variables.
. $PSScriptRoot\script_variables.ps1

# Create a Storage Account.
az deployment group create `
  --name "storage_account" `
  --resource-group "$resourceGroupName" `
  --template-file "$PSScriptRoot\storage_account.bicep" `
  --parameters "$PSScriptRoot\storage_account.parameters.json" `
  --parameters blobContainerName=$storageAccountBlobContainerName `
               storageAccountName=$storageAccountName 

# Get the key for the Storage Account.
$storageAccountKey = az storage account keys list --account-name $storageAccountName --query "[?keyName == 'key1'].value" --output tsv

# Save the Storage Account key to .NET user secrets for the console app.
dotnet user-secrets set "storage:accountKey" $storageAccountKey --project ".\BlobConsole\BlobConsole\BlobConsole.csproj"
dotnet user-secrets set "storage:accountName" $storageAccountName --project ".\BlobConsole\BlobConsole\BlobConsole.csproj"