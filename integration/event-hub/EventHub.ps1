# *****************************************************************************
#
# File:        EventHub.ps1
#
# Description: Creates an Event Hub.
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

# Create the Event Hub.
New-AzureRmResourceGroupDeployment -Name "EventHub" `
	-ResourceGroupName $resourceGroupName `
    -TemplateFile "$PSScriptRoot\EventHub-azuredeploy.json" `
	-TemplateParameterFile "$PSScriptRoot\EventHub-azuredeploy.parameters.json"
