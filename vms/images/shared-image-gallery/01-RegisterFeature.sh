# *****************************************************************************
#
# File:        01-RegisterFeature.sh
#
# Description: Registers the feature for the Shared Image Gallery.
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

# Register the feature.
#az feature register --namespace Microsoft.Compute --name GalleryPreview

# Register the provider.
#az provider register -n Microsoft.Compute

# Check if the feature is pending or registered.
az feature show --namespace Microsoft.Compute -n GalleryPreview
