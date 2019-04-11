# *****************************************************************************
#
# File:        CreateManagedSnapshotFromManagedDisk.ps1
#
# Description: Creates a Managed Snapshot from a Managed Disk.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the existing Managed Disk.
$diskName = "DestVM_disk1_f3fd6a08436a48ebb8cea4b423803f1d"
# Location of the existing Managed Disk and the Managed Snapshot to create.
$location = "Canada East"
# Name of the Resource Group.
$resourceGroupName = "BB-MD"
# Name of the Managed Snapshot to create.
$snapshotName = "MySnapshot1"

# Get the Managed Disk.
$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName -DiskName $diskName

# Create a Managed Snapshot Configuration.
$snapshot =  New-AzureRmSnapshotConfig -SourceUri $disk.Id -CreateOption Copy -Location $location

# Create the Managed Snapshot from the Snapshot Configuration.
New-AzureRmSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName
