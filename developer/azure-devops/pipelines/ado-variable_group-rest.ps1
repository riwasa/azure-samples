# *****************************************************************************
#
# File:        ado-variable_group-rest.ps1
#
# Description: Creates an Azure DevOps Variable Group linked to a Key Vault,
#              using REST API calls.
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

$organizationName = "<replace-with-name-of-ADO-organization>"
$projectName = "<replace-with-name-of-ADO-project>"
$serviceConnectionName = "<replace-with-name-of-Azure-Service-Connection>"

$variableGroupName = "<replace-with-name-of-variable-group>"
$variableGroupDescription = "<replace-with-description-of-variable-group>"
$vaultName = "<replace-with-name-of-key-vault>"

# Get Service Connections. PAT must have Service Connections permissions.
$personalAccessToken = "<replace-with-personal-access-token>"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "", $personalAccessToken)))

$uri = "https://dev.azure.com/" + $organizationName + "/" + $projectName + "/_apis/serviceendpoint/endpoints?api-version=7.1-preview.4"
$serviceConnections = Invoke-RestMethod -Uri $uri -Method Get -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo) }

foreach ($serviceConnection in $serviceConnections.value)
{
  Write-Host $serviceConnection.id / $serviceConnection.Name
  if ($serviceConnection.Name -eq $serviceConnectionName) {
    $serviceConnectionId = $serviceConnection.id
  }
}

# Get Project ids. PAT must have Project and Team permissions.
$personalAccessToken = "<replace-with-personal-access-token>"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "", $personalAccessToken)))

$uri = "https://dev.azure.com/" + $organizationName + "/_apis/projects?api-version=5.0-preview.3"
$projects = Invoke-RestMethod -Uri $uri -Method Get -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo) }

foreach ($project in $projects.value)
{
  Write-Host $project.id / $project.name
  if ($project.Name -eq $projectName) {
    $projectId = $project.id
  }
}

# Create a variable group. PAT must have Variable Groups permissions.
$personalAccessToken = "<replace-with-personal-access-token>"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "", $personalAccessToken)))

$body = "{ 
  'authorized': true,
  'description': '$variableGroupDescription',
  'name': '$variableGroupName',
  'type': 'AzureKeyVault',
  'variableGroupProjectReferences': [
    {
      'projectReference': {
        'id': '$projectId',
        'name': '$projectName'
      }, 
      'name': '$variableGroupName',
      'description': '$variableGroupDescription'
    }
  ],
  'providerData': { 
    'serviceEndpointId': '$serviceConnectionId',
    'vault': '$vaultName'
  }, 
  'variables': {
    'mysecret': {
      'enabled': true,
      'contentType': '',
      'value': null,
      'isSecret': true 
    }
  }
}"

$uri = "https://dev.azure.com/" + $organizationName + "/" + $projectName + "/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"

Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" `
  -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo) } -Body $body
