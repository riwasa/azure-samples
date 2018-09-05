# *****************************************************************************
#
# File:        CreateManagedImageFromVHD.ps1
#
# Description: Creates a Managed Image from a generalized VHD Blob.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the Managed Image to create.
$imageName = "MyImageA1"
# Location for the VHD Blob and the Managed Image to create.
$location = "Canada East"
# Specify the path to the source VHD.
# A SAS token cannot be specified for the source. The user executing this 
# script must have full access to the Storage Account containing the VHD.
# The VHD must be generalized.
$osDiskVhdUri = "https://rimbbmd.blob.core.windows.net/vhds/SourceVM20170622125237.vhd"
# Name of the Resource Group.
$resourceGroupName = "BB-MD"

# Create a Managed Image Configuration.
$imageConfig = New-AzureRmImageConfig -Location $location

# Add the OS disk definition to the Image Configuration. The disk can be resized.
Set-AzureRmImageOsDisk -Image $imageConfig -OsType 'Linux' -OsState 'Generalized' -BlobUri $osDiskVhdUri -DiskSizeGB 50

# Create the Managed Image from the Image Configuration.
New-AzureRmImage -Image $imageConfig -ImageName $imageName -ResourceGroupName $resourceGroupName