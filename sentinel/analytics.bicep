@description('Name of the Log Analytics workspace that Microsoft Sentinel is enabled on (e.g. law-sec-ops).')
param workspaceName string

@description('Whether to deploy Sentinel Scheduled Analytics Rules from the sentinel/analytics JSON templates.')
param deploySentinelAnalytics bool = true

// Load JSON definitions for the three analytics rules
var identityAlert = loadJsonContent('analytics/identity-impossible-travel.json')
var networkAlert  = loadJsonContent('analytics/network-high-volume-deny.json')
var aksAlert      = loadJsonContent('analytics/aks-public-registry-pods.json')

// Existing Log Analytics workspace (Sentinel-enabled)
resource workspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' existing = {
  name: workspaceName
}

resource identityImpossibleTravel 'Microsoft.SecurityInsights/alertRules@2020-01-01' = if (deploySentinelAnalytics) {
  scope: workspace
  name: identityAlert.name
  kind: 'Scheduled'
  properties: identityAlert.properties
}

resource networkHighVolumeDeny 'Microsoft.SecurityInsights/alertRules@2020-01-01' = if (deploySentinelAnalytics) {
  scope: workspace
  name: networkAlert.name
  kind: 'Scheduled'
  properties: networkAlert.properties
}

resource aksPublicRegistryPods 'Microsoft.SecurityInsights/alertRules@2020-01-01' = if (deploySentinelAnalytics) {
  scope: workspace
  name: aksAlert.name
  kind: 'Scheduled'
  properties: aksAlert.properties
}
