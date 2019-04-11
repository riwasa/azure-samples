#!/bin/bash

# *****************************************************************************
#
# File:        CreateManagedImageFromManagedDisk.sh
#
# Description: Creates a Managed Image from a Managed Disk.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the existing Managed Disk.
diskName="DestVM_disk1_f3fd6a08436a48ebb8cea4b423803f1d"
# Name of the Managed Image to create.
imageName="MyImage4"
# Name of the Resource Group.
resourceGroupName="BB-MD"
# Id of the Subscription.
subscriptionId=$(az account show --query "id" -o tsv)

# Create the Managed Image.
az image create --resource-group $resourceGroupName --name $imageName --os-type Linux \
	--source /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/disks/$diskName
