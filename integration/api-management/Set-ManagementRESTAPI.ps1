# *****************************************************************************
#
# File:        Set-ManagementRESTAPI.ps1
#
# Description: Disables the Management REST API for an API Management Services.
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
$resourceGroupName = "<enter-resource-group-name-here>"
$apimServiceName = "<enter-apim-service-name-here>"

$apim = Get-AzApiManagement -ResourceGroupName $resourceGroupName `
  -Name $apimServiceName

# Get an access token to call ARM APIs for the current user.
$azContext = Get-AzContext
$azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
$profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
$token = $profileClient.AcquireAccessToken($azContext.Subscription.TenantId)
$authHeader = @{
    'Content-Type'='application/json'
    'Authorization'='Bearer ' + $token.AccessToken
}

# Check if the Management REST API is enabled. There is no PowerShell command to check this;
# you must make an ARM API call.
$managementApiEnabled = $false

try
{
  $restUri = "https://management.azure.com" + $apim.Id + "/tenant/access?api-version=2019-12-01"
  $response = Invoke-WebRequest -Uri $restUri -Method Get -Headers $authHeader
    
  if ($null -ne $response) {
    $responseObject =  ConvertFrom-Json $response 
        
    if ($responseObject.enabled -eq "true") {
      $managementApiEnabled = $true
    }
  }
}
catch
{
  $showException = $false

  if ($_.Exception.Response.StatusCode -eq 400) {
    $errorDetails = ConvertFrom-Json $_.ErrorDetails.Message

    if ($errorDetails.error.code -ne "MethodNotAllowedInPricingTier") {
      $showException = $true
    } else {
      # The API Management Service tier does not support the Management REST API.
      Write-Host $apimServiceName "does not support the Management REST API"

      exit
    }
  }

  if ($showException -eq $true) {
    # An unexpected exception occurred; show it for debugging purposes.
    Write-Host $_.ErrorDetails.Message

    exit
  }
}

$response = $null
$responseObject = $null

if ($managementApiEnabled -eq $true) {
  Write-Host $apimServiceName "has the Management REST API enabled"
} else {
  Write-Host $apimServiceName "does not have the Management Rest API enabled"
  exit
}

try
{
  $body = "{""properties"": { ""enabled"": false}}"
  $restUri = "https://management.azure.com" + $apim.Id + "/tenant/access?api-version=2019-12-01"
  $response = Invoke-WebRequest -Uri $restUri -Method Patch -Headers $authHeader -Body $body

  if ($null -ne $response) {
    if ($response.StatusCode -eq 204) {
      Write-Host "Management REST API has been disabled"
    } else {
      Write-Host "ERR: Could not disable Management REST API"
      exit
    }
  }
}
catch
{
  $showException = $false

  if ($_.Exception.Response.StatusCode -eq 400) {
    $errorDetails = ConvertFrom-Json $_.ErrorDetails.Message

    if ($errorDetails.error.code -ne "MethodNotAllowedInPricingTier") {
      $showException = $true
    } else {
      # The API Management Service tier does not support the Management REST API.
      Write-Host $apimServiceName "does not support the Management REST API"

      exit
    }
  }

  if ($showException -eq $true) {
    # An unexpected exception occurred; show it for debugging purposes.
    Write-Host $_.ErrorDetails.Message

    exit
  }
}