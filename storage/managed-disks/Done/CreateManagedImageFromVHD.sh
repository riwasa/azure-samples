#!/bin/bash

# *****************************************************************************
#
# File:        CreateManagedImageFromVHD.sh
#
# Description: Creates a Managed Image from a generalized VHD Blob.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Name of the Managed Image to create.
imageName="MyImageA2"
# Location for the VHD Blob and the Managed Image to create.
location="CanadaEast"
# Specify the path to the source VHD.
# A SAS token cannot be specified for the source. The user executing this 
# script must have full access to the Storage Account containing the VHD.
# The VHD must be generalized.
osDiskVhdUri="https://rimbbmd.blob.core.windows.net/vhds/SourceVM20170622125237.vhd"
# Name of the Resource Group.
resourceGroupName="BB-MD"

# Create the Managed Image from the Blob.
az image create --resource-group $resourceGroupName --name $imageName --location $location --os-type Linux \
	--source $osDiskVhdUri