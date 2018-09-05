# *****************************************************************************
#
# File:        CreateManagedDiskFromVHD.ps1
#
# Description: Creates a Managed Disk from a generalized VHD Blob.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the Managed Disk to create.
$diskName = "MyDiskA1"
# Location for the VHD Blob and the Managed Disk to create.
$location = "Canada East"
# Specify the path to the source VHD.
# A SAS token cannot be specified for the source. The user executing this 
# script must have full access to the Storage Account containing the VHD.
# The VHD must be generalized.
$osDiskVhdUri = "https://rimbbmd.blob.core.windows.net/vhds/SourceVM20170622125237.vhd"
# Name of the Resource Group.
$resourceGroupName = "BB-MD"

# Create a Managed Disk Configuration.
$diskConfig = New-AzureRmDiskConfig -AccountType StandardLRS -CreateOption Import -OsType Linux -Location $location `
	-SourceUri $osDiskVhdUri -DiskSizeGB 95

# Create the Managed Disk from the Disk Configuration.
New-AzureRmDisk -Disk $diskConfig -DiskName $diskName -ResourceGroupName $resourceGroupName
