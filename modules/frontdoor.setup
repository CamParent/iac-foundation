// =====================================================
// frontdoor.bicep — Azure Front Door Standard/Premium
// =====================================================

@description('Front Door profile name.')
param profileName string

@description('Front Door endpoint name.')
param endpointName string

@description('Origin group name.')
param originGroupName string = 'og-appservice'

@description('Origin name.')
param originName string = 'origin-appservice'

@description('Route name.')
param routeName string = 'route-default'

@description('Origin hostname, e.g. myapp.azurewebsites.net')
param originHostName string

@description('Tags applied to resources.')
param tags object = {}

@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
param skuName string = 'Standard_AzureFrontDoor'

resource afdProfile 'Microsoft.Cdn/profiles@2024-09-01-preview' = {
  name: profileName
  location: 'global'
  sku: {
    name: skuName
  }
  tags: tags
  properties: {
    originResponseTimeoutSeconds: 120
  }
}

resource afdEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2024-09-01-preview' = {
  name: endpointName
  parent: afdProfile
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource afdOriginGroup 'Microsoft.Cdn/profiles/originGroups@2024-09-01-preview' = {
  name: originGroupName
  parent: afdProfile
  properties: {
    sessionAffinityState: 'Disabled'
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'GET'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 120
    }
  }
}

resource afdOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2024-09-01-preview' = {
  name: originName
  parent: afdOriginGroup
  properties: {
    hostName: originHostName
    originHostHeader: originHostName
    httpPort: 80
    httpsPort: 443
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    certificateNameCheckEnabled: true
  }
}

resource afdRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-09-01-preview' = {
  name: routeName
  parent: afdEndpoint
  properties: {
    originGroup: {
      id: afdOriginGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    httpsRedirect: 'Enabled'
    linkToDefaultDomain: 'Enabled'
    enabledState: 'Enabled'
  }
}

output frontDoorProfileId string = afdProfile.id
output frontDoorEndpointHostName string = afdEndpoint.properties.hostName