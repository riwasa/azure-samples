#!/bin/bash

# *****************************************************************************
#
# File:        CreateImageFromVM.sh
#
# Description: Creates a Managed Image from a Virtual Machine.
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

# Name of the Managed Image to create.
imageName="ImageFromVMsh"
# Name of the Resource Group.
resourceGroupName="Sample-MD"
# Name of the Virtual Machine.
vmName="BaseVM"

# The Virtual Machine should be generalized before running this script.
# sudo waagent -deprovision+user

# Stop and deallocate the Virtual Machine.
az vm deallocate --resource-group $resourceGroupName --name $vmName

# Set the status of the Virtual Machine to Generalized.
az vm generalize --resource-group $resourceGroupName --name $vmName

# Create the Managed Image.
az image create --resource-group $resourceGroupName --name $imageName --source $vmName
