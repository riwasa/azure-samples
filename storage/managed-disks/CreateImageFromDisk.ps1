# *****************************************************************************
#
# File:        CreateImageFromDisk.ps1
#
# Description: Creates a Managed Image from a Managed Disk.
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

# Name of the existing Managed Disk.
$diskName = "BaseVM_OsDisk_1_ea8d624069124528ab4a4d1f6c7db1aa"
# Name of the Managed Image to create.
$imageName = "ImageFromDiskps"
# Location of the existing Managed Disk and the Managed Image to create.
$location = "Canada Central"
# OS type of the disk (Windows or Linux).
$osType = "Windows"
# Name of the Resource Group.
$resourceGroupName = "Sample-MD"

# Get the existing Managed Disk.
$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName -DiskName $diskName

# Create a Managed Image configuration.
$imageConfig = New-AzureRmImageConfig -Location $location

# Add the OS disk definition to the image configuration. Note that trying to resize with the DiskSizeGB parameter
# will result in an InternalExecutionError.
Set-AzureRmImageOsDisk -Image $imageConfig -OsType $osType -OsState 'Generalized' -ManagedDiskId $disk.id

# Create the Managed Image.
New-AzureRmImage -Image $imageConfig -ImageName $imageName -ResourceGroupName $resourceGroupName
