// =====================================================
// main.bicep — Subscription-scope orchestration
// =====================================================
targetScope = 'subscription'

// ---------------------------
// Parameters
// ---------------------------
@description('Primary deployment region.')
param location string = 'eastus2'

@description('Short name prefix for hub resources (e.g., "hub").')
param namePrefixHub string = 'hub'

@description('Short name prefix for spoke resources (e.g., "spoke-app").')
param namePrefixSpoke string = 'spoke-app'

@description('Hub resource group name.')
param hubRgName string = 'rg-hub-networking'

@description('Spoke resource group name.')
param spokeRgName string = 'rg-spoke-app'

@description('Shared services resource group name.')
param sharedRgName string = 'rg-shared-services'

@description('Hub VNet CIDR (the hub networking module expects string).')
param hubAddressSpace string = '10.1.0.0/16'

@description('Spoke VNet CIDR (the spoke networking module expects string).')
param spokeAddressSpace string = '10.2.0.0/16'

@description('Hub subnets object used by the hub networking module.')
param hubSubnets object = {
  firewall:   '10.1.0.0/26'
  management: '10.1.0.64/26'
  workloads:  '10.1.1.0/24'
}

@description('App subnet prefix inside the spoke VNet.')
param appSubnetPrefix string = '10.2.1.0/24'

@description('Subnet prefix for the AKS node pool, e.g. "10.2.10.0/24".')
param aksSubnetPrefix string = '10.2.10.0/24'

@allowed([ 'Standard', 'Premium' ])
@description('Azure Firewall SKU.')
param firewallSku string = 'Standard'

@allowed([ 'Alert', 'Deny', 'Off' ])
@description('Azure Firewall threat intel mode.')
param threatIntelMode string = 'Deny'

@description('Deploy Key Vault (in shared RG)?')
param deployKeyVault bool = true

@description('Tags applied by modules that support tags.')
param tags object = {
  environment: 'dev'
  workload: 'foundation'
  owner: 'cam'
}

@description('Toggle policy deployment')
param deployPolicies bool = false

@description('Deploy AKS cluster into the spoke VNet?')
param deployAks bool = false

@description('Azure AD group object IDs to grant AKS admin access.')
param aksAdminGroupObjectIds array = []

// ---------------------------
// Resource Groups (idempotent)
// ---------------------------
resource rgHub 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: hubRgName
  location: location
  tags: tags
}

resource rgSpoke 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: spokeRgName
  location: location
  tags: tags
}

resource rgShared 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: sharedRgName
  location: location
  tags: tags
}

// =====================================================
// 1) HUB NETWORK
//    outputs: vnetId, firewallSubnetId, managementSubnetId, workloadsSubnetId, vnetName
// =====================================================
module hubNet './modules/networking.bicep' = {
  name: 'mod-hub-networking'
  scope: rgHub
  params: {
    location: location
    namePrefix: namePrefixHub
    addressSpace: hubAddressSpace
    subnets: hubSubnets
    tags: tags
  }
}

// =====================================================
// 2) FIREWALL (in hub)
//    requires: firewallSubnetId
//    outputs: firewallId, firewallPublicIp, firewallName
// =====================================================
module firewall './modules/firewall.bicep' = {
  name: 'mod-hub-firewall'
  scope: rgHub
  params: {
    location: location
    namePrefix: namePrefixHub
    firewallSku: firewallSku
    threatIntelMode: threatIntelMode
    firewallSubnetId: hubNet.outputs.firewallSubnetId
    tags: tags
  }
}

// =====================================================
// 3) SHARED KEY VAULT (optional)
//    outputs: keyVaultId, keyVaultName, pfxSecretId
// =====================================================
module keyVault './modules/keyvault.bicep' = if (deployKeyVault) {
  name: 'mod-keyvault'
  scope: rgShared
  params: {
    location: location
    namePrefix: 'cert-store-aks-001'
    enableRbacAuthorization: true
    tags: tags
  }
}

// =====================================================
// 4) LOG ANALYTICS WORKSPACE (required for AKS monitoring)
//    outputs: logAnalyticsWorkspaceId
// =====================================================
module logAnalytics './modules/loganalytics.bicep' = {
  name: 'mod-loganalytics'
  scope: rgShared
  params: {
    location: location
    namePrefix: 'law'
    tags: tags
  }
}

// =====================================================
// 5) SPOKE NETWORK
//    outputs: vnetId, appSubnetId, vnetName
// =====================================================
module spoke './modules/spoke-networking.bicep' = {
  name: 'mod-spoke-networking'
  scope: rgSpoke
  params: {
    location: location
    namePrefix: namePrefixSpoke
    addressSpace: spokeAddressSpace
    appSubnetPrefix: appSubnetPrefix
    aksSubnetPrefix: aksSubnetPrefix
    tags: tags
  }
}

// =====================================================
// 6) HUB ↔ SPOKE PEERING (call RG-scoped module twice)
// =====================================================

// Hub ➜ Spoke
module hubToSpoke './modules/peering.bicep' = {
  name: 'mod-hub-to-spoke'
  scope: resourceGroup(hubRgName)
  params: {
    localVnetName: hubNet.outputs.vnetName
    remoteVnetId:  spoke.outputs.vnetId
    allowVnetAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

// Spoke ➜ Hub
module spokeToHub './modules/peering.bicep' = {
  name: 'mod-spoke-to-hub'
  scope: resourceGroup(spokeRgName)
  params: {
    localVnetName: spoke.outputs.vnetName
    remoteVnetId:  hubNet.outputs.vnetId
    allowVnetAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

// =====================================================
// 7) AKS CLUSTER (optional)
//    Deploys a private AKS cluster into the spoke VNet
// =====================================================
module aks './modules/aks.bicep' = if (deployAks) {
  name: 'mod-aks-${namePrefixSpoke}'
  scope: rgSpoke
  params: {
    location: location
    aksName: '${namePrefixSpoke}-aks'
    aksSubnetId: spoke.outputs.aksSubnetId
    adminGroupObjectIds: aksAdminGroupObjectIds
    tags: tags
    logAnalyticsWorkspaceId: logAnalytics.outputs.logAnalyticsWorkspaceId
  }
}

// =====================================================
// 8)Policy
// =====================================================

module policies './modules/policy.bicep' = if (deployPolicies) {
  name: 'mod-policies'
  scope: subscription()
  params: {
    allowedLocations: [ location ]           // e.g., 'eastus2'
  }
}

// ---------------------------
// Outputs (handy for pipelines)
// ---------------------------
output hubVnetId string       = hubNet.outputs.vnetId
output spokeVnetId string     = spoke.outputs.vnetId
output firewallPublicIp string = firewall.outputs.firewallPublicIp
output keyVaultId string = deployKeyVault ? keyVault.outputs.keyVaultId : ''
output aksName string  = deployAks ? aks.outputs.aksNameOut : ''
output aksFqdn string  = deployAks ? aks.outputs.aksFqdn : ''
