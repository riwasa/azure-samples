# *****************************************************************************
#
# File:        service_principal.ps1
#
# Description: Creates a Service Principal.
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

# Get the subscription id.
$subscriptionId = $(az account show | ConvertFrom-Json).id

$servicePrincipalId = (az ad sp list --display-name $servicePrincipalName --query "[0]" | ConvertFrom-Json).id

if ($null -eq $servicePrincipalId) {
    # Create a Service Principal.
    # Grant the Service Principal the Storage Blob Data Contributor role, which contains
    # the Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey action.
    $servicePrincipal = az ad sp create-for-rbac --name $servicePrincipalName `
        --role "Storage Blob Data Contributor" `
        --scopes "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageAccountName/blobServices/default/containers/$storageAccountBlobContainerName" `
        | ConvertFrom-Json

    Write-Host $servicePrincipal

    # Save the Service Principal info to .NET user secrets for the console app.
    dotnet user-secrets set "sp:appId" $servicePrincipal.appId --project ".\BlobConsole\BlobConsole\BlobConsole.csproj"
    dotnet user-secrets set "sp:appPassword" $servicePrincipal.password --project ".\BlobConsole\BlobConsole\BlobConsole.csproj"
    dotnet user-secrets set "sp:tenantId" $servicePrincipal.tenant --project ".\BlobConsole\BlobConsole\BlobConsole.csproj"
}
