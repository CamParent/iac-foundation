@description('Region')
param location string

@description('Key Vault name')
param name string

@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('Common tags')
param tags object

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: skuName
      family: 'A'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    softDeleteRetentionInDays: 7
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
  tags: tags
}

output keyVaultId string = kv.id
output keyVaultUri string = kv.properties.vaultUri
