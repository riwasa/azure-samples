# *****************************************************************************
#
# File:        CreateVMFromManagedImage.ps1
#
# Description: Creates a Virtual Machine from a Managed Image.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Create the Virtual Machine from a Managed Image.
New-AzureRmResourceGroupDeployment -Name VMFromImage -ResourceGroupName "BB-MD" `
    -TemplateFile "$PSScriptRoot\CreateVMFromManagedImage-azuredeploy.json" `
	-TemplateParameterFile "$PSScriptRoot\CreateVMFromManagedImage-azuredeploy.parameters.json"
