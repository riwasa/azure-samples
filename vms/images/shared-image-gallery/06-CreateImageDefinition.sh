# *****************************************************************************
#
# File:        06-CreateImageDefinition.sh
#
# Description: Creates an image definition in a Shared Image Gallery.
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

# Create an image definition.
az sig image-definition create -g "$resourceGroupName" --gallery-name "$galleryName" \
  --gallery-image-definition "$imageDefinition" \
  --publisher "riwasa" --offer "WindowsServer" --sku "2016-Datacenter" \
  --os-type "Windows"
