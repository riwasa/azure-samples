# *****************************************************************************
#
# File:        11-CreateVMFromSharedImageInvalidRegion.sh
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
vmResourceGroupName="Demo-SIG-cac"
vmName="FromImgcacVM"

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
az vm create --resource-group "$vmResourceGroupName" --name "$vmName" \
   --image "$imageId" --admin-username "$adminUsername" --admin-password "$adminPassword"

#Deployment failed. Correlation ID: 0bf0faee-67c9-49b2-b7bc-50da215e8265. {
#  "error": {
#    "code": "ImageNotFound",
#    "target": "imageReference",
#    "message": "The platform image '/subscriptions/55eb90af-e6e7-4061-baf0-cf30e260a0b7/resourceGroups/Demo-Image/providers/Microsoft.Compute/galleries/DemoImagesig/images/Win2016ImageDefinition/versions/1.0.0' is not available. Verify that all fields in the storage profile are correct."
#  }
#}