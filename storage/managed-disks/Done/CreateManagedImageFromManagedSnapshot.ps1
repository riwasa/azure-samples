# *****************************************************************************
#
# File:        CreateManagedImageFromManagedSnapshot.ps1
#
# Description: Creates a Managed Image from a Managed Snapshot.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the Managed Image to create.
$imageName = "MyImage7"
# Location of the existing Managed Snapshot and the Managed Image to create.
$location = "Canada East"
# Name of the Resource Group.
$resourceGroupName = "BB-MD"
# Name of the existing Managed Snapshot.
$snapshotName = "MySnapshot1"

# Get the existing Managed Snapshot.
$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName

# Create a Managed Image Configuration.
$imageConfig = New-AzureRmImageConfig -Location $location

# Add the OS disk definition to the Image Configuration. Note that trying to resize with the DiskSizeGB parameter
# will result in an InternalExecutionError.
Set-AzureRmImageOsDisk -Image $imageConfig -OsType 'Linux' -OsState 'Generalized' -SnapshotId $snapshot.id

# Create the Managed Image from the Image Configuration.
New-AzureRmImage -Image $imageConfig -ImageName $imageName -ResourceGroupName $resourceGroupName
