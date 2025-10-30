targetScope = 'subscription'

// ---------- Global parameters ----------
@description('Deployment location for resource groups and resources')
param location string

@allowed([
  'dev'
  'test'
  'prod'
])
param env string = 'dev'

// Short prefix used in resource names
@minLength(2)
param namePrefix string = 'demo'

// Centralized tags
var tags = {
  env: env
  owner: 'Cam Parent'
  project: 'iac-foundation'
}

// ---------- Resource group names ----------
var rgHubName    = 'rg-hub-networking'
var rgSharedName = 'rg-shared-services'
var rgSpokeName  = 'rg-spoke-app'

// ---------- Ensure RGs exist (safe if already created) ----------
resource rgHub 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgHubName
  location: location
  tags: tags
}

resource rgShared 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgSharedName
  location: location
  tags: tags
}

resource rgSpoke 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgSpokeName
  location: location
  tags: tags
}

// ---------- Hub networking module ----------
module networking './modules/networking.bicep' = {
  name: 'mod-networking'
  scope: resourceGroup(rgHub.name)
  params: {
    location: location
    namePrefix: namePrefix
    hubAddressSpace: [
      '10.1.0.0/16'
    ]
    firewallSubnetPrefix: '10.1.1.0/24'
    workloadsSubnetPrefix: '10.1.2.0/24'
    tags: tags
  }
}

// ---------- Azure Firewall module (depends on hub networking) ----------
module firewall './modules/firewall.bicep' = {
  name: 'mod-firewall'
  scope: resourceGroup(rgHub.name)
  params: {
    location: location
    namePrefix: namePrefix
    firewallSubnetId: networking.outputs.firewallSubnetId
    sku: 'Standard'       // or 'Premium'
    threatIntelMode: 'AlertAndDeny' // 'Alert' | 'Deny' | 'Off' | 'AlertAndDeny'
    tags: tags
  }
}

// ---------- Optional: shared Key Vault (cert store) ----------
module kv './modules/keyvault.bicep' = {
  name: 'mod-keyvault'
  scope: resourceGroup(rgShared.name)
  params: {
    location: location
    name: '${namePrefix}-kv-cert-store'   // distinct from your existing name if you keep both
    skuName: 'standard'
    tags: tags
    // principals: []  // add later
  }
}

// Future: spoke networking, App Gateway WAF, routes, etc.
// module appgw './modules/appgw-waf.bicep' = { ... }
