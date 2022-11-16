// *****************************************************************************
//
// File:        virtual_network.bicep
//
// Description: Creates a Virtual Network and Bastion Host.
//
// THE SOFTWARE IS PROVIDED 'AS IS' WITHOUT WARRANTY OF ANY KIND EXPRESS OR
// IMPLIED INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM DAMAGES OR OTHER
// LIABILITY WHETHER IN AN ACTION OF CONTRACT TORT OR OTHERWISE ARISING FROM
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// *****************************************************************************

@description('An Array of 1 or more IP address prefixes.')
param addressPrefixes array

@description('The name of of the App Service Environment.')
param appServiceEnvironmentName string

@description('The name of the subnet for the App Service Environment.')
param appServiceEnvironmentSubnetName string

@description('The location of the resources.')
param location string = resourceGroup().location

@description('An Array of subnets.')
param subnets array = []

@description('The name of the Virtual Network.')
param virtualNetworkName string

var delegations = [
  {
    name: '${appServiceEnvironmentName}-delegation'
    properties: {
      serviceName: 'Microsoft.Web/hostingEnvironments'
    }
  }
]

// Create a Virtual Network.
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        delegations: subnet.name == appServiceEnvironmentSubnetName ? delegations : null
        privateEndpointNetworkPolicies: 'Enabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
    }]
  }
}
