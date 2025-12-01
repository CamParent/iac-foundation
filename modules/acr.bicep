@description('Name of the Azure Container Registry')
param acrName string

@description('SKU/tier of the ACR (Basic, Standard, or Premium)')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param acrSku string = 'Standard'

@description('Location for ACR (defaults to resource group location)')
param location string = resourceGroup().location

@description('Tags to apply to the ACR')
param tags object

@description("Principal ID of AKS cluster's managed identity for RBAC")
param aksPrincipalId string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-05-01' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: false
  }
  tags: tags
}

resource acrPullAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(containerRegistry.id, aksPrincipalId, 'AcrPull')
  scope: containerRegistry
  properties: {
    principalId: aksPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalType: 'ServicePrincipal'
  }
}

output acrName string = containerRegistry.name
output acrLoginServer string = containerRegistry.properties.loginServer
output acrResourceId string = containerRegistry.id
