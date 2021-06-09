# *****************************************************************************
#
# File:        Remove-DefaultEchoAPI.ps1
#
# Description: Removes the default Echo API from an API Management Service.
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

$apimContext = New-AzApiManagementContext -ResourceGroupName $resourceGroupName `
  -ServiceName $apimServiceName

$apis = Get-AzApiManagementApi -Context $apimContext     

foreach ($api in $apis) {
  if ($api.Name -eq "Echo API") {
    Write-Host "Deleting Echo API"
    Remove-AzApiManagementApi -Context $apimContext -ApiId $api.ApiId
  }
}
