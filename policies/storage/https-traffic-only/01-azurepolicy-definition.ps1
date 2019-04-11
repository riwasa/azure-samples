# *****************************************************************************
#
# File:        01-azurepolicy-definition.ps1
#
# Description: Creates a policy to require Storage Accounts to allow only
#              HTTPS connections.
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
New-AzPolicyDefinition -Name "require-storage-https-traffic-only" `
  -DisplayName "Require HTTPS for Storage Accounts" `
  -Description "This policy requires that Storage Accounts allow only HTTPS connections." `
  -Policy "$PSScriptRoot\azurepolicy.rules.json"
