# *****************************************************************************
#
# File:        05-CreateSharedImageGallery.sh
#
# Description: Creates a Shared Image Gallery.
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

# Create a Shared Image Gallery. The gallery name can only have
# uppercase letters, lowercase letters, or numbers.
az sig create -g "$resourceGroupName" --gallery-name "$galleryName"