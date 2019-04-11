# *****************************************************************************
#
# File:        03-CreateWinVM.sh
#
# Description: Creates a Windows Server 2016 VM.
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
vmName="BaseVM"
adminUsername="rimadmin"

# Get the local admin password to use.
echo -n "Please enter a password to use for the local admin account on the VM:"
read -s adminPassword
echo

# Create the Virtual Machine.
az vm create --resource-group "$resourceGroupName" --name "$vmName" \
  --image win2016datacenter --admin-username "$adminUsername" --admin-password "$adminPassword"
