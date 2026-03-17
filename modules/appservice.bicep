// =====================================================
// appservice.bicep — App Service Plan + Web App origin
// =====================================================

@description('Primary deployment region.')
param location string

@description('Web app name. Must be globally unique.')
param webAppName string

@description('App Service plan name.')
param appServicePlanName string

@description('Tags applied to resources.')
param tags object = {}

@allowed([
  'F1'
  'B1'
])
@description('App Service plan SKU. Use B1 for predictable learning labs; F1 may have platform limitations.')
param skuName string = 'B1'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: skuName == 'F1' ? 'Free' : 'Basic'
    size: skuName
    capacity: 1
  }
  kind: 'app'
  properties: {
    reserved: false
  }
  tags: tags
}

resource webApp 'Microsoft.Web/sites@2024-04-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      alwaysOn: skuName == 'F1' ? false : true
    }
  }
  tags: tags
}

output webAppName string = webApp.name
output webAppId string = webApp.id
output defaultHostname string = webApp.properties.defaultHostName
