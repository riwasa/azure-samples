#!/bin/bash

# *****************************************************************************
#
# File:        StorageAccount.sh
#
# Description: Creates a Storage Account.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
# *****************************************************************************

# Prompt for the name of the Resource Group.
echo -n "Please enter the name of the existing Resource Group to use: "
read resourceGroupName
echo

# Create the Storage Account.
storageAccountName=$(az group deployment create --name "Storage" \
	--resource-group $resourceGroupName \
	--template-file "StorageAccount-azuredeploy.json" \
	--output tsv \
	--query "properties.outputs.storageAccountName.value" \
	--parameters @"StorageAccount-azuredeploy.parameters.json")

echo "Storage Account Name:" $storageAccountName

# Get the Storage Account.
storageAccountKey=$(az storage account keys list --resource-group $resourceGroupName \
    --account-name $storageAccountName --query "[0].value" | tr -d '"')

# Set environment variables for later storage commands.
export AZURE_STORAGE_ACCESS_KEY=$storageAccountKey 
export AZURE_STORAGE_ACCOUNT=$storageAccountName
