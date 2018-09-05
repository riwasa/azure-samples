#!/bin/bash

# *****************************************************************************
#
# File:        EventHubNamespace.sh
#
# Description: Creates an Event Hub Namespace.
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

# Create the Event Hub Namespace.
az group deployment create --name "EventHubNS" \
	--resource-group $resourceGroupName \
	--template-file "EventHubNamespace-azuredeploy.json" \
	--parameters @"EventHubNamespace-azuredeploy.parameters.json"
