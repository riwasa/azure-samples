# *****************************************************************************
#
# File:        CreateManagedSnapshotFromVHD.ps1
#
# Description: Creates a Managed Snapshot from a generalized VHD Blob.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Location for the VHD Blob and the Managed Snapshot to create.
$location = "Canada East"
# Specify the path to the source VHD.
# A SAS token cannot be specified for the source. The user executing this 
# script must have full access to the Storage Account containing the VHD.
# The VHD must be generalized.
$osDiskVhdUri = "https://rimbbmd.blob.core.windows.net/vhds/SourceVM20170622125237.vhd"
# Name of the Resource Group.
$resourceGroupName = "BB-MD"
# Name of the Managed Snapshot to create.
$snapshotName = "MySnapshotA1"

# Create a Managed Snapshot Configuration.
$snapshot = New-AzureRmSnapshotConfig -SourceUri $osDiskVhdUri -CreateOption Import -Location $location

# Create the Managed Snapshot from the Snapshot Configuration.
New-AzureRmSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName


