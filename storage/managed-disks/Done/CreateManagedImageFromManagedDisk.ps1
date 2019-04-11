# *****************************************************************************
#
# File:        CreateManagedImageFromManagedDisk.ps1
#
# Description: Creates a Managed Image from a Managed Disk.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the existing Managed Disk.
$diskName = "DestVM_disk1_f3fd6a08436a48ebb8cea4b423803f1d"
# Name of the Managed Image to create.
$imageName = "MyImage6"
# Location of the existing Managed Disk and the Managed Image to create.
$location = "Canada East"
# Name of the Resource Group.
$resourceGroupName = "BB-MD"

# Get the existing Managed Disk.
$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName -DiskName $diskName

# Create a Managed Image Configuration.
$imageConfig = New-AzureRmImageConfig -Location $location

# Add the OS disk definition to the Image Configuration. Note that trying to resize with the DiskSizeGB parameter
# will result in an InternalExecutionError.
Set-AzureRmImageOsDisk -Image $imageConfig -OsType 'Linux' -OsState 'Generalized' -ManagedDiskId $disk.id

# Create the Managed Image from the Image Configuration.
New-AzureRmImage -Image $imageConfig -ImageName $imageName -ResourceGroupName $resourceGroupName
