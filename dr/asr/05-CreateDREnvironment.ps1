# *****************************************************************************
#
# File:        05-CreateDREnvironment.ps1
#
# Description: Creates the DR environment.
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

# Create the DR environment.
New-AzResourceGroupDeployment -Name DREnvironment -ResourceGroupName $drResourceGroupName `
  -TemplateFile "$PSScriptRoot\05-CreateDREnvironment-azuredeploy.json" `
  -TemplateParameterFile "$PSScriptRoot\05-CreateDREnvironment-azuredeploy.parameters.json" `
