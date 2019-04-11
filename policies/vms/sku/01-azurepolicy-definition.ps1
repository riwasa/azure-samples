# *****************************************************************************
#
# File:        01-azurepolicy-definition.ps1
#
# Description: Creates a policy to prevent creation of G-Series VMs.
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

# Create the Policy definition.
New-AzPolicyDefinition -Name "deny-vm-g-series" `
  -DisplayName "Prevent G-series VM creation" `
  -Description "This policy prevents creation of G-series VMs." `
  -Policy "$PSScriptRoot\azurepolicy.rules.json"
