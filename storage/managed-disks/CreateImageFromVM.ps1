# *****************************************************************************
#
# File:        CreateImageFromVM.ps1
#
# Description: Creates a Managed Image from a Virtual Machine.
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

# Name of the Managed Image to create.
$imageName = "ImageFromVM01"
# Location of the existing Managed Disk and the Managed Image to create.
$location = "Canada Central"
# Name of the Resource Group.
$resourceGroupName = "Sample-MD"
# Name of the Virtual Machine.
$vmName = "Base1VM"

# The Virtual Machine should be generalized before running this script.
# Use sysprep.exe.

# Stop and deallocate the Virtual Machine.
Stop-AzureRmVM -ResourceGroupName $resourceGroupName -Name $vmName -Force

# Set the status of the Virtual Machine to Generalized.
Set-AzureRmVm -ResourceGroupName $resourceGroupName -Name $vmName -Generalized

# Get the Virtual Machine.
$vm = Get-AzureRmVM -ResourceGroupName $resourceGroupName -Name $vmName

# Create a Managed Image configuration.
$image = New-AzureRmImageConfig -Location $location -SourceVirtualMachineId $vm.ID

# Create the Managed Image.
New-AzureRmImage -Image $image -ImageName $imageName -ResourceGroupName $resourceGroupName
