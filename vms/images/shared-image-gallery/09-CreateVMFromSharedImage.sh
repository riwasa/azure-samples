# *****************************************************************************
#
# File:        09-CreateVMFromSharedImage.sh
#
# Description: Creates a VM from an image in a Shared Image Gallery.
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
galleryName="demosig"
imageDefinition="Win2016ImageDefinition"
adminUsername="rimadmin"
vmName="FromImgVM"

# Get the id of the current subscription.
subId=$(az account list --query "[?isDefault].id" --output tsv)

# Construct the id of the VM managed image.
imageId="/subscriptions/$subId/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/galleries/$galleryName/images/$imageDefinition/versions/1.0.0"

# Get the local admin password to use.
echo -n "Please enter a password to use for the local admin account on the VM:"
read -s adminPassword
echo

echo $imageId

# Create a 
az vm create --resource-group $resourceGroupName --name "$vmName" \
   --image "$imageId" --admin-username "$adminUsername" --admin-password "$adminPassword"
