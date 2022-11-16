// *****************************************************************************
//
// File:        app_service_environment.bicep
//
// Description: Creates an App Service Environment.
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

@description('The name of the App Service Environment.')
param appServiceEnvironmentName string

@description('Specifies whether to create a private DNS zone.')
param createPrivateDnsZone bool = true

@description('Specifies which endpoints to service internally in the Virtual Network.')
@allowed([
  'None'
  'Publishing'
  'Web'
  'Web, Publishing'
])
param internalLoadBalancingMode string

@description('The location of the resources.')
param location string = resourceGroup().location

@description('The name of the subnet for the App Service Environment.')
param subnetName string

@description('The name of the Virtual Network.')
param virtualNetworkName string

@description('Specifies whether the App Service Environment is zone redundant.')
param zoneRedundant bool = false

// Get the DNS suffix for the App Service Environment once created, to use for the private DNS zone name.
var privateDnsZoneName = appServiceEnvironment.properties.dnsSuffix

// Get a reference to the Virtual Network and subnet.
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' existing = {
  name: subnetName
  parent: virtualNetwork
}

// Create an App Service Environment.
resource appServiceEnvironment 'Microsoft.Web/hostingEnvironments@2022-03-01' = {
  name: appServiceEnvironmentName
  location: location
  kind: 'ASEV3'
  properties: {
    clusterSettings: [
      {
        name: 'DisableTls1.0'
        value: '1'
      }
    ]
    internalLoadBalancingMode: internalLoadBalancingMode
    virtualNetwork: {
      id: subnet.id
    }
    zoneRedundant: zoneRedundant
  }
  resource configuration 'configurations' = {
    name: 'networking'
    properties: {
      allowNewPrivateEndpointConnections: true
    }
  }
}

// Create a private DNS zone.
module privateDnsZone 'app_service_environment-private_dns_zone.bicep' = if (createPrivateDnsZone) {
  name: 'private_dns_zone'
  params: {
    appServiceEnvironmentName: appServiceEnvironmentName
    privateDnsZoneName: privateDnsZoneName
    virtualNetworkId: virtualNetwork.id
  }
}
