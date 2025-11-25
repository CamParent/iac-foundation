@description('Location for the Log Analytics workspace')
param location string

@description('Tags for resources')
param tags object

@description('Name prefix for the workspace (e.g., "law")')
param namePrefix string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: '${namePrefix}-sec-ops'
  location: location
  sku: {
    name: 'PerGB2018'
  }
  properties: {
    retentionInDays: 30
  }
  tags: tags
}

output logAnalyticsWorkspaceId string = logAnalytics.id
