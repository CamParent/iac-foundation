@description('Azure region')
param location string

@description('Name prefix for firewall resources, e.g. "hub" -> fw-hub, pip-fw-hub')
param namePrefix string

@allowed([ 'Standard', 'Premium' ])
@description('Azure Firewall SKU tier')
param firewallSku string = 'Standard'

@allowed([ 'Alert', 'Deny', 'Off' ])
@description('Firewall threat intel mode')
param threatIntelMode string = 'Deny'

@description('ID of the AzureFirewallSubnet in the hub VNet')
param firewallSubnetId string

@description('Optional tags')
param tags object = {}

var pipName       = 'pip-fw-${namePrefix}'
var firewallName  = 'fw-${namePrefix}'

// Public IP for the firewall
resource pip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: pipName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  tags: tags
}

// Azure Firewall
resource fw 'Microsoft.Network/azureFirewalls@2022-09-01' = {
  name: firewallName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: firewallSku
    }
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
}

output firewallId string        = fw.id
output firewallPublicIp string  = pip.properties.ipAddress
output firewallName string      = fw.name
