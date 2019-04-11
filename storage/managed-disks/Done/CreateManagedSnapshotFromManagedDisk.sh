#!/bin/bash

# *****************************************************************************
#
# File:        CreateManagedSnapshotFromManagedDisk.sh
#
# Description: Creates a Managed Snapshot from a Managed Disk.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the existing Managed Disk.
diskName="DestVM_disk1_f3fd6a08436a48ebb8cea4b423803f1d"
# Name of the Resource Group.
resourceGroupName="BB-MD"
# Name of the Managed Snapshot to create.
snapshotName="MySnapshot3"

# Get the id of the existing Managed Disk.
diskId=$(az disk show --resource-group $resourceGroupName --name $diskName --query "id" --output tsv)

# Create a Managed Snapshot.
az snapshot create --resource-group $resourceGroupName --source $diskId --name $snapshotName
