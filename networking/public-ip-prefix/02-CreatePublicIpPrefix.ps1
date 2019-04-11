# *****************************************************************************
#
# File:        02-CreatePublicIpPrefix.ps1
#
# Description: Creates a Public IP Prefix.
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

# Script variables.
$resourceGroupName="Demo-PublicIPPrefix"
$location="West Central US"
$publicIpPrefixName="Demo-PublicIPPrefix-pippfx"
# CIDR prefix (e.g. 29 for /29 or 8 IP addresses; 21 is the minimum value).
$cidrPrefix=30

# Create the Public IP Prefix.
New-AzureRmPublicIpPrefix -Name $publicIpPrefixName -ResourceGroupName $resourceGroupName `
    -PrefixLength $cidrPrefix -IpAddressVersion IPv4 -Location $location
