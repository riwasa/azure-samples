# *****************************************************************************
#
# File:        Check-APIManagement.ps1
#
# Description: Checks API Management Services in an Azure Subscription,
#              to see if they have the Management REST API enabled, or 
#              if they contain the default Echo API.
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

# Get an access token to call ARM APIs for the current user.
$azContext = Get-AzContext
$azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
$profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
$token = $profileClient.AcquireAccessToken($azContext.Subscription.TenantId)
$authHeader = @{
    'Content-Type'='application/json'
    'Authorization'='Bearer ' + $token.AccessToken
}

# Get all API Management Services in the current Azure Subscription.
$apimServices = Get-AzApiManagement

foreach ($apimService in $apimServices) {
  Write-Host "Checking" $apimService.Name
  
  # Check if the Management REST API is enabled. There is no PowerShell command to check this;
  # you must make an ARM API call.
  $managementApiEnabled = $false

  try
  {
    $restUri = "https://management.azure.com" + $apimService.Id + "/tenant/access?api-version=2019-12-01"
    $response = Invoke-WebRequest -Uri $restUri -Method Get -Headers $authHeader
    
    if ($response -ne $null) {
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
        # The API Management Service tier does not support the Management REST API.
        $showException = $true
      }
    }

    if ($showException -eq $true) {
      # An unexpected exception occurred; show it for debugging purposes.
      Write-Host $_.ErrorDetails.Message
    }
  }

  if ($managementApiEnabled -eq $true) {
    Write-Host "ERR:" $apimService.Name "has the Management REST API enabled"
  } else {
    Write-Host "INF:" $apimService.Name "does not have the Management Rest API enabled"
  }

  $response = $null
  $responseObject = $null

  # Check if the API Management Service contains a default sample API.
  $containsDefaultApi = $false

  $apimContext = New-AzApiManagementContext -ResourceGroupName $apimService.ResourceGroupName `
    -ServiceName $apimService.Name

  $apis = Get-AzApiManagementApi -Context $apimContext     

  foreach ($api in $apis) {
    if ($api.Name -eq "Echo API") {
      $containsDefaultApi = $true
    }
  }
  
  if ($containsDefaultApi -eq $true) {
    Write-Host "ERR:" $apimService.Name "contains default Echo API"
  } else {
    Write-Host "INF:" $apimService.Name "does not contain default Echo API"
  }  
}
