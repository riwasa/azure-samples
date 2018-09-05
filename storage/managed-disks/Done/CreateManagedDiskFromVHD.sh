#!/bin/bash

# *****************************************************************************
#
# File:        CreateManagedDiskFromVHD.sh
#
# Description: Creates a Managed Disk from a generalized VHD Blob.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the Managed Disk to create.
diskName="MyDiskA2"
# Specify the path to the source VHD.
# A SAS token cannot be specified for the source. The user executing this 
# script must have full access to the Storage Account containing the VHD.
# The VHD must be generalized.
osDiskVhdUri="https://rimbbmd.blob.core.windows.net/vhds/SourceVM20170622125237.vhd"
# Name of the Resource Group.
resourceGroupName="BB-MD"

# Create the Managed Disk from the Blob.
az disk create --resource-group $resourceGroupName --name $diskName --source $osDiskVhdUri
