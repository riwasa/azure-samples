# *****************************************************************************
#
# File:        12-DeleteResourceGroup.sh
#
# Description: Deletes Resource Groups.
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
vm1Name="Demo-SIG-wcus"
vm2Name="Demo-SIG-cac"

# Delete the Resource Group.
az group delete -g "$resourceGroupName"

# Delete the Resource Group for alternate VM provisioning.
az group delete -g "$vm1Name"

# Delete the Resource Group for invalid VM provisioning.
az group delete -g "$vm2Name"
