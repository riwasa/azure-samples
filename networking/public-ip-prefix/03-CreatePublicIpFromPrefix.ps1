# *****************************************************************************
#
# File:        03-CreatePublicIpFromPrefix.ps1
#
# Description: Creates a Public IP Address from a Public IP Prefix.
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
$publicIpName="Demo-PublicIPPrefix6-pip"
$domainName="rimdemopublicipprefix6"

# Get the Public IP Prefix. Note the PublicIPAddresses property contains id's for
# any Public IP Addresses created from the prefix.
$publicIpPrefix = Get-AzureRmPublicIpPrefix -Name $publicIpPrefixName -ResourceGroupName $resourceGroupName

# Show the number of Public IP Address resources linked to the Prefix.
Write-Host $publicIpPrefix.PublicIpAddresses.Count

# Create the Public IP Address from the Public IP Prefix.
# An InternalServerError will be returned if the prefix has no unassigned IP addresses remaining: note 
# a Public IP Address will still be created, but with the IpAddress property not assigned.
New-AzureRmPublicIpAddress -Name $publicIpName -ResourceGroupName $resourceGroupName `
    -Sku Standard -AllocationMethod Static -IpAddressVersion IPv4 `
    -DomainNameLabel $domainName -PublicIpPrefix $publicIpPrefix -Location $location
