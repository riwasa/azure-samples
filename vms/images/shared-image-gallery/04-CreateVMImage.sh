# *****************************************************************************
#
# File:        04-CreateVMImage.sh
#
# Description: Creates a Managed Image from the VM.
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
imageName="BaseVM-img"

# Stop the VM.
az vm deallocate --resource-group "$resourceGroupName" --name "$vmName"

# Mark the VM as generalized.
az vm generalize --resource-group "$resourceGroupName" --name "$vmName"

# Create an image from the VM.
az image create --resource-group "$resourceGroupName" --name "$imageName" --source "$vmName"
