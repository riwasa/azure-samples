# *****************************************************************************
#
# File:        data-explorer.ps1
#
# Description: Creates an Azure Data Explorer cluster.
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

$resourceGroupName = Read-Host -Prompt "Enter the name of the Resource Group"

# Create the environment.
New-AzResourceGroupDeployment -Name data-explorer -ResourceGroupName $resourceGroupName `
  -TemplateFile "$PSScriptRoot\data-explorer-azuredeploy.json" `
  -TemplateParameterFile "$PSScriptRoot\data-explorer-azuredeploy.parameters.json"
