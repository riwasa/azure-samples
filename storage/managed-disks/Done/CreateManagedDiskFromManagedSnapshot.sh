#!/bin/bash

# *****************************************************************************
#
# File:        CreateManagedDiskFromManagedSnapshot.sh
#
# Description: Creates a Managed Disk from a Managed Snapshot.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the Managed Disk to create.
diskName="MyDiskA"
# Name of the Resource Group.
resourceGroupName="BB-MD"
# Name of the existing Managed Snapshot.
snapshotName="MySnapshot"
# Id of the Subscription.
subscriptionId=$(az account show --query "id" -o tsv)

# Create the Managed Disk.
az disk create --resource-group $resourceGroupName --name $diskName --os-type Linux \
	--source /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/snapshots/$snapshotName
