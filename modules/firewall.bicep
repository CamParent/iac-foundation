@description('Region for resources')
param location string

@description('Name prefix for resources')
param namePrefix string

// Remove this param if you’re not using it yet
// param vnetId string

@description('AzureFirewallSubnet resource ID')
param firewallSubnetId string

@allowed([
  'Standard'
  'Premium'
  'Basic'
])
param sku string = 'Standard'

@allowed([
  'Alert'
  'Deny'
  'Off'
  'AlertAndDeny'
])
param threatIntelMode string = 'Alert'

@description('Common tags')
param tags object

// Public IP (Standard)
resource pip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'pip-${namePrefix}-fw'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  tags: tags
}

// Azure Firewall (use API version compatible with top-level sku)
resource firewall 'Microsoft.Network/azureFirewalls@2022-09-01' = {
  name: '${namePrefix}-fw'
  location: location
  sku: {
    name: 'AZFW_VNet'
    tier: sku     // 'Standard' | 'Premium' | 'Basic'
  }
  properties: {
    threatIntelMode: threatIntelMode
    ipConfigurations: [
      {
        name: 'azureFirewallIpConfig'
        properties: {
          subnet: {
            id: firewallSubnetId
          }
          publicIPAddress: {
            id: pip.id
          }
        }
      }
    ]
  }
  tags: tags
}

output firewallId string = firewall.id
output firewallPublicIp string = pip.properties.ipAddress
