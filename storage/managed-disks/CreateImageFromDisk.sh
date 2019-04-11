#!/bin/bash

# *****************************************************************************
#
# File:        CreateImageFromDisk.sh
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
diskName="BaseVM_OsDisk_1_ea8d624069124528ab4a4d1f6c7db1aa"
# Name of the Managed Image to create.
imageName="ImageFromDisksh"
# Location of the existing Managed Disk and the Managed Image to create.
location="Canada Central"
# OS type of the disk (Windows or Linux).
osType="Windows"
# Name of the Resource Group.
resourceGroupName="Sample-MD"
# Id of the Subscription.
subscriptionId=$(az account show --query "id" -o tsv)

# Create the Managed Image.
az image create --resource-group $resourceGroupName --name $imageName --os-type $osType \
	--source /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/disks/$diskName
