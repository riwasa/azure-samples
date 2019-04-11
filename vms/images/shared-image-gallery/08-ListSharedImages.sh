# *****************************************************************************
#
# File:        08-ListSharedImages.sh
#
# Description: Lists images in a Shared Image Gallery.
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

# List the image definitions in a gallery, including information about OS type and status. 
az sig image-definition list -g $resourceGroupName -r $galleryName -o table

# List the shared image versions in a gallery
az sig image-version list -g $resourceGroupName -r $galleryName -i $imageDefinition 

# Get the ID of an image version. 
az sig image-version show \
  -g $resourceGroupName \
  -r $galleryName \
  -i $imageDefinition \
  --gallery-image-version-name 1.0.0 \
  --query "id"