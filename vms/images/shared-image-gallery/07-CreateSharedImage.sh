# *****************************************************************************
#
# File:        07-CreateSharedImage.sh
#
# Description: Creates an image in a Shared Image Gallery.
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
imageName="BaseVM-img"

# Get the id of the current subscription.
subId=$(az account list --query "[?isDefault].id" --output tsv)

# Construct the id of the VM managed image.
imageId="/subscriptions/$subId/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/images/$imageName"

# Create an image version, using the specified managed image previously created.
# Create 1 replica in West Central US, and 2 replicas in East US 2.
az sig image-version create \
   -g $resourceGroupName \
   --gallery-name $galleryName \
   --gallery-image-definition $imageDefinition \
   --gallery-image-version 1.0.0 \
   --target-regions "WestCentralUS=1" "EastUS2" \
   --replica-count 2 \
   --managed-image "$imageId"
