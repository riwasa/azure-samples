# *****************************************************************************
#
# File:        02-CreateResourceGroup.sh
#
# Description: Creates Resource Groups.
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
resourceGroupName="Demo-SIG"
location="East US 2"
vm1Name="Demo-SIG-wcus"
vm1Location="West Central US"
vm2Name="Demo-SIG-cac"
vm2Location="Canada Central"

# Create the Resource Group.
az group create -g "$resourceGroupName" -l "$location"

# Create a Resource Group for alternate VM provisioning.
az group create -g "$vm1Name" -l "$vm1Location"

# Create a Resource Group for invalid VM provisioning.
az group create -g "$vm2Name" -l "$vm2Location"
