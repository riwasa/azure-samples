// *****************************************************************************
//
// File:        storage.bicep
//
// Description: Creates a Storage Account.
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

@description('The access tier.')
@allowed([
  'Cool'
  'Hot'
  'Premium'
])
param accessTier string

@description('Indicates if public access to all blobs or containers is allowed.')
param allowBlobPublicAccess bool = false

@description('Indicates if objects can be replicated across AAD tenants.')
param allowCrossTenantReplication bool = false

@description('Indicates if requests can be authorized with the account access key.')
param allowSharedKeyAccess bool = true

@description('Indicates if Microsoft Entra authorization is the default in the Azure portal.')
param defaultToOAuthAuthentication bool = false

@description('The type of endpoint for the Storage Account.')
@allowed([
  'AzureDnsZone'
  'Standard'
])
param dnsEndpointType string = 'Standard'

@description('Indicates if Hierarchical Namespace is enabled.')
param isHnsEnabled bool = false

@description('Indicates if local users are enabled to access blobs with SFTP or files with SMB.')
param isLocalUserEnabled bool = false

@description('Indicates if NFS 3.0 protocol support is enabled.')
param isNfsV3Enabled bool = false

@description('Indicates if SSH FTP access is enabled.')
param isSftpEnabled bool = false

@description('The type of Storage Account.')
@allowed([
  'Blobstorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param kind string

@description('The location of the resources.')
param location string = resourceGroup().location

@description('The minimum TLS version permitted on requests.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

@description('The id of the principal to assign roles to.')
param principalId string = ''

@description('Indicates if public network access is allowed to the Storage Account.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Role definition ids or names to assign to the principal.')
param roleDefinitionIdsOrNames array = []

@description('The name of the SKU.')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param skuName string

@description('The name of the Storage Account.')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Indicates if only HTTPS traffic is allowed.')
param supportsHttpsTrafficOnly bool = true

// Create a Storage Account.
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: kind
  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: allowBlobPublicAccess
    allowCrossTenantReplication: allowCrossTenantReplication
    allowSharedKeyAccess: allowSharedKeyAccess
    defaultToOAuthAuthentication: defaultToOAuthAuthentication
    dnsEndpointType: dnsEndpointType
    isHnsEnabled: isHnsEnabled
    isLocalUserEnabled: isLocalUserEnabled
    isNfsV3Enabled: isNfsV3Enabled
    isSftpEnabled: isSftpEnabled
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: publicNetworkAccess
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
  }
  sku: {
    name: skuName
  }
}

// Assign roles to the principal.
module storageRbacModule 'storage-rbac.bicep' = if (!empty(principalId) && !empty(roleDefinitionIdsOrNames)) {
  name: 'StorageRBAC'
  params: {
    principalId: principalId
    roleDefinitionIdsOrNames: roleDefinitionIdsOrNames
    storageAccountName: storageAccountName
  }
}
