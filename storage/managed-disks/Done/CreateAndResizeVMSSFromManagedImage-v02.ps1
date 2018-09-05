# *****************************************************************************
#
# File:        CreateAndResizeVMSSFromManagedImage-v02.ps1
#
# Description: Creates a Virtual Machine Scale Set from a Managed Image and
#              resizes the OS disk in the ARM template.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
# OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# 
# *****************************************************************************

# Create the Virtual Machine Scale Set from a Managed Image.
New-AzureRmResourceGroupDeployment -Name VMFromImage -ResourceGroupName "BB-MD" `
    -TemplateFile "$PSScriptRoot\CreateAndResizeVMSSFromManagedImage-azuredeploy-v02.json" `
	-TemplateParameterFile "$PSScriptRoot\CreateAndResizeVMSSFromManagedImage-azuredeploy.parameters-v02.json"
