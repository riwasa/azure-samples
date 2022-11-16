// *****************************************************************************
//
// File:        application_insights.bicep
//
// Description: Creates an Application Insights Component.
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

@description('The name of the Application Insights Component.')
param applicationInsightsName string

@description('The type of application being monitored.')
@allowed([
  'other'
  'web'
])
param applicationType string

@description('The workspace daily quota for ingestion.')
@minValue(-1)
param dailyQuotaGb int = -1

@description('The kind of application that this component refers to, used to customize UI.')
@allowed([
  'ios'
  'java'
  'other'
  'phone'
  'store'
  'web'
])
param kind string

@description('The location of the resources.')
param location string

@description('The name of the Log Analytics Workspace.')
param logAnalyticsName string

@description('The network access type for accessing Application Insights ingestion.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccessForIngestion string

@description('The network access type for accessing Application Insights query.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccessForQuery string

@description('The retention period in days.')
@allowed([
  30
  60
  90
  120
  180
  270
  365
  550
  730
])
param retentionInDays int

// Create a Log Analytics Workspace.
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
  }
}

// Create an Application Insights Component.
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: kind
  properties:{
    Application_Type: applicationType
    Flow_Type: 'Bluefield'
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    Request_Source: 'rest'
    RetentionInDays: retentionInDays
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}
