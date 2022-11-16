// *****************************************************************************
//
// File:        logic_app.bicep
//
// Description: Creates a Logic App.
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

@description('The name of the Application Insights Component for the Logic App..')
param applicationInsightsComponentName string

@description('The name of the App Service Environment.')
param appServiceEnvironmentName string

@description('The name of the App Service Plan for the Logic App.')
param appServicePlanName string

@description('The location of the resources.')
param location string = resourceGroup().location

@description('The name of the Logic App.')
param logicAppName string

@description('The name of the SKU.')
param skuName string

@description('The tier of the SKU.')
param skuTier string

@description('The name of the Storage Account for the Logic App.')
param storageAccountName string

// Get the App Service Environment.
resource appServiceEnvironment 'Microsoft.Web/hostingEnvironments@2022-03-01' existing = {
  name: appServiceEnvironmentName
}

// Create an App Service Plan.
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  properties: {
    hostingEnvironmentProfile: {
      id: appServiceEnvironment.id
    }
  }
  sku: {
    name: skuName
    tier: skuTier
  }
}

// Get the Application Insights Component.
resource applicationInsightsComponent 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsComponentName
}

// Get the Storage Account.
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

// Create a Logic App.
resource logicApp 'Microsoft.Web/sites@2022-03-01' = {
  name: logicAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'functionapp,workflowapp'
  properties: {
    clientAffinityEnabled: false
    hostingEnvironmentProfile: {
      id: appServiceEnvironment.id
    } 
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'APP_KIND'
          value: 'workflowApp'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsightsComponent.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsightsComponent.properties.ConnectionString
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__id'
          value: 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__version'
          value: '[1.*, 2.0.0)'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~14'
        }
        {
          name: 'WEBSITE_VNET_ROUTE_ALL'
          value: '1'
        }
      ]
      alwaysOn: true
      cors: {}
      ftpsState: 'FtpsOnly'
      netFrameworkVersion: 'v6.0'
      use32BitWorkerProcess: true
    }
    serverFarmId: appServicePlan.id
  }
  tags: {
    'hidden-link: /app-insights-resource-id': applicationInsightsComponent.id
  }
}
