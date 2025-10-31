@description('Azure region')
param location string

@description('Name prefix, e.g. "cert-store-615" -> kv-cert-store-615')
param namePrefix string

@description('Optional tags')
param tags object = {}

@description('Enable RBAC auth for KV (recommended). If false, access policies must be used.')
param enableRbacAuthorization bool = true

@description('Optional PFX certificate upload (base64). Leave empty to skip.')
param pfxBase64 string = ''

var kvName = toLower('kv-${namePrefix}')

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: kvName
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    enablePurgeProtection: true
    enableSoftDelete: true
    enableRbacAuthorization: enableRbacAuthorization
    sku: { family: 'A', name: 'standard' }
    networkAcls: { bypass: 'AzureServices', defaultAction: 'Allow' }
  }
}

resource pfxSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = if (pfxBase64 != '') {
  name: 'tls-pfx'
  parent: kv
  properties: {
    value: pfxBase64
    contentType: 'application/x-pkcs12'
  }
}

output keyVaultId string   = kv.id
output keyVaultName string = kv.name
output pfxSecretId string  = pfxBase64 != '' ? pfxSecret.id : ''
