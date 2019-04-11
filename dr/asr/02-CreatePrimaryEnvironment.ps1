# *****************************************************************************
#
# File:        02-CreatePrimaryEnvironment.ps1
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

# Get script variables.
. $PSScriptRoot\00-ScriptVariables.ps1

# Get the local admin password to use.
$password = Get-Password

# Create the primary environment.
New-AzResourceGroupDeployment -Name PrimaryEnvironment -ResourceGroupName $primaryResourceGroupName `
  -TemplateFile "$PSScriptRoot\02-CreatePrimaryEnvironment-azuredeploy.json" `
  -TemplateParameterFile "$PSScriptRoot\02-CreatePrimaryEnvironment-azuredeploy.parameters.json" `
  -adminPassword $password
