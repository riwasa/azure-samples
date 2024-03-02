# *****************************************************************************
#
# File:        storage.ps1
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

# Get script variables.
$resourceGroupName = "<resource-group-name>"
$location = "<region>"

$principalId = "<object-id-of-user>"
$storageAccountName = "<name-of-storage-account>"

# Create a Storage Account.
Write-Host "Creating a Storage Account."

az deployment group create `
  --name "storage" `
  --resource-group "$resourceGroupName" `
  --template-file "storage.bicep" `
  --parameters "storage.parameters.json" `
  --parameters location=$location `
               principalId=$principalId `
               storageAccountName=$storageAccountName
