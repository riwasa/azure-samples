// Name of the Application Insights instance.
param applicationInsightsName string

// Name of the Log Analytics Workspace.
param logAnalyticsName string

// Resource location.
param location string

// Type of application being monitored.
@allowed([
  'other'
  'web'
])
param applicationType string

// The workspace daily quota for ingestion.
param dailyQuotaGb int

// Disable IP masking.
param disableIpMasking bool

// The network access type for accessing Application Insights ingestion.
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccessForIngestion string

// The network access type for accessing Application Insights query.
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccessForQuery string

// The workspace data retention in days, between 30 and 730.
param retentionInDays int

// Percentage of the data produced by the application being monitored that is being sampled for Application Insights telemetry.
param samplingPercentage int

// Create a Log Analytics Workspace.
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    retentionInDays: retentionInDays
    sku: {
      name: 'PerGB2018'
    }
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
  }
}

// Create an Application Insights Component.
resource applicationInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: applicationInsightsName
  location: location
  dependsOn: [
    logAnalyticsWorkspace
  ]
  kind: 'web'
  properties: {
    Application_Type: applicationType
    DisableIpMasking: disableIpMasking
    Flow_Type: 'Bluefield'
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    Request_Source: 'rest'
    SamplingPercentage: samplingPercentage
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}
