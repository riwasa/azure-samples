# *****************************************************************************
#
# File:        CreateManagedDiskFromManagedSnapshot.ps1
#
# Description: Creates a Managed Disk from a Managed Snapshot.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the Managed Disk to create.
$diskName = "MyDiskB"
# Location of the existing Managed Snapshot and the Managed Disk to create.
$location = "Canada East"
# Name of the Resource Group.
$resourceGroupName = "BB-MD"
# Name of the existing Managed Snapshot.
$snapshotName = "MySnapshot1"

# Get the existing Managed Snapshot.
$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName

# Create a Managed Disk Configuration.
$diskConfig = New-AzureRmDiskConfig -AccountType StandardLRS -CreateOption Copy -OsType Linux -Location $location `
	-SourceResourceId $snapshot.Id -DiskSizeGB 95

# Create the Managed Disk from the Disk Configuration.
New-AzureRmDisk -Disk $diskConfig -DiskName $diskName -ResourceGroupName $resourceGroupName
