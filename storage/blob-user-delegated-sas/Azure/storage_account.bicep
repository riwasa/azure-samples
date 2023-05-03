// *****************************************************************************
//
// File:        key_vault.bicep
//
// Description: Creates a Key Vault.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// *****************************************************************************

@description('The access tier used for billing. Required for storage accounts where kind = BlobStorage.')
@allowed([
  'Cool'
  'Hot'
])
param accessTier string

@description('Indicates if access should be allowed from all networks.')
param allowAccessFromAllNetworks bool

@description('Indicates if public access can be enabled for blobs or containers in the storage account.')
param allowBlobPublicAccess bool

@description('Indicates if network restrictions are bypassed for logging.') 
param allowBypassLogging bool

@description('Indicates if network restrictions are bypassed for metrics. ')
param allowBypassMetrics bool

@description('Indicates if network restrictions are bypassed for trusted Azure services.')
param allowBypassTrustedServices bool
 
@description('Indicates if the storage account permits requests to be authorized with the account access key via Shared Key.')
param allowSharedKeyAccess bool

@description('Indicates if the change feed is enabled.')
param blobChangeFeed bool

@description('The name of the blob container.')
param blobContainerName string

@description('Indicates if blob soft delete is enabled.')
param blobSoftDelete bool

@description('The number of days a deleted blob should be retained.')
param blobSoftDeleteRetentionInDays int = 0

@description('Indicates if blob versioning is enabled.')
param blobVersioning bool

@description('Indicates if container soft delete is enabled.')
param containerSoftDelete bool

@description('The number of days a deleted container should be retained.')
param containerSoftDeleteRetentionInDays int = 0

@description('Indicates if hierarchical namespace is enabled.')
param isHnsEnabled bool

@description('Indicates if NFS 3.0 protocol support is enabled.')
param isNfsV3Enabled bool

@description('The type of the Storage Account.')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param kind string

@description('The location of resources.')
param location string = resourceGroup().location

@description('The minimum TLS version to be permitted on requests to storage.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string

@description('The default network routing preference.')
@allowed([
  'InternetRouting'
  'MicrosoftRouting'
])
param routingChoice string

@description('Indicates if Microsoft routing storage endpoints are to be published.')
param routingPublishMicrosoftEndpoints bool

@description('Indicates if internet routing storage endpoints are to be published.')
param routingPublishInternetEndpoints bool

@description('The name of the SKU.')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param skuName string

@description('The name of the Storage Account.')
param storageAccountName string

@description('Indicates if only https traffic is allowed.')
param supportsHttpsTrafficOnly bool

var defaultAction = (allowAccessFromAllNetworks ? 'Allow' : 'Deny')
var isBypass = allowBypassLogging || allowBypassMetrics || allowBypassTrustedServices
var bypassRaw = isBypass ? format('{0}{1}{2}', allowBypassLogging ? 'Logging, ' : '', allowBypassMetrics ? 'Metrics, ' : '', allowBypassTrustedServices ? 'AzureServices, ' : '') : ''
var bypassLength = isBypass ? (length(bypassRaw) - 2) : 0
var bypassValue = isBypass ? (endsWith(bypassRaw, ', ') ? substring(bypassRaw, 0, bypassLength) : bypassRaw) : 'None'

// Create a Storage Account.
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: kind
  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: allowBlobPublicAccess
    allowSharedKeyAccess: allowSharedKeyAccess
    isHnsEnabled: isHnsEnabled
    isNfsV3Enabled: isNfsV3Enabled
    minimumTlsVersion: minimumTlsVersion
    networkAcls: {
      bypass: bypassValue
      defaultAction: defaultAction
    }
    routingPreference: {
      publishInternetEndpoints: routingPublishInternetEndpoints
      publishMicrosoftEndpoints: routingPublishMicrosoftEndpoints
      routingChoice: routingChoice
    }
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
  }  
  sku: {
    name: skuName
  }
}

// Create blob services.
resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    changeFeed: {
      enabled: blobChangeFeed
    }
    containerDeleteRetentionPolicy: {
      days: (containerSoftDelete ? containerSoftDeleteRetentionInDays : json('null'))
      enabled: containerSoftDelete
    }
    deleteRetentionPolicy: {
      days: (blobSoftDelete ? blobSoftDeleteRetentionInDays : json('null'))
      enabled: blobSoftDelete
    }
    isVersioningEnabled: blobVersioning
  }
}

// Create a blob container.
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: blobContainerName
  parent: blobServices
}
