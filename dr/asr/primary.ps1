# *****************************************************************************
#
# File:        primary.ps1
#
# Description: Creates the primary environment.
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

New-AzureRmResourceGroupDeployment -Name simple-vm -ResourceGroupName $resourceGroupName `
  -TemplateFile "$PSScriptRoot\simple-vm-azuredeploy.json" `
	-TemplateParameterFile "$PSScriptRoot\simple-vm-azuredeploy.parameters.json"
  az deployment create -l southcentralus --template-file ./azuredeploy.json --parameters roleAssignmentName={random seed}