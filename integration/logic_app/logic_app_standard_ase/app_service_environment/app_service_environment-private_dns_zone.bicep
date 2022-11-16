// *****************************************************************************
//
// File:        app_service_environment-private_dns_zone.bicep
//
// Description: Creates a Private DNS Zone for an App Service Environment.
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

@description('The name of the Private DNS Zone.')
param privateDnsZoneName string

@description('The id of the Virtual Network.')
param virtualNetworkId string

// Get the networking configuration of the App Service Environment.
resource appServiceEnvironmentConfig 'Microsoft.Web/hostingEnvironments/configurations@2022-03-01' existing = {
  name: '${appServiceEnvironmentName}/networking'
}

// Create a Private DNS Zone.
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
  properties: {}
}

// Link the Private DNS Zone to the Virtual Network.
resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: 'vnetLink'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}

// Create an A record for the web endpoint.
resource webRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: privateDnsZone
  name: '*'
  properties: {
    aRecords: [
      {
        ipv4Address: appServiceEnvironmentConfig.properties.internalInboundIpAddresses[0]
      }
    ]
    ttl: 3600
  }
}

// Create an A record for the management endpoint.
resource scmRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: privateDnsZone
  name: '*.scm'
  properties: {
    aRecords: [
      {
        ipv4Address: appServiceEnvironmentConfig.properties.internalInboundIpAddresses[0]
      }
    ]
    ttl: 3600
  }
}

// Create an A record for the root domain.
resource atRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: privateDnsZone
  name: '@'
  properties: {
    aRecords: [
      {
        ipv4Address: appServiceEnvironmentConfig.properties.internalInboundIpAddresses[0]
      }
    ]
    ttl: 3600    
  }
}
