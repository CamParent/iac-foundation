@description('Azure region')
param location string
@description('Name prefix for all resources in this module, e.g. "hub" -> vnet-hub')
param namePrefix string
@description('Hub VNet address space, e.g. "10.1.0.0/16"')
param addressSpace string
@description('Subnet prefixes for the hub VNet')
param subnets object
@description('Optional tags')
param tags object = {}

var vnetName  = 'vnet-${namePrefix}'
var snMgmt    = 'sn-${namePrefix}-mgmt'
var snWork    = 'sn-${namePrefix}-workloads'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: [ addressSpace ] }
    subnets: [
      { name: 'AzureFirewallSubnet', properties: { addressPrefix: subnets.firewall } }
      { name: snMgmt,                 properties: { addressPrefix: subnets.management } }
      { name: snWork,                 properties: { addressPrefix: subnets.workloads } }
    ]
  }
}

// declare subnets as existing for clean, stable IDs
resource firewallSubnet  'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  parent: vnet
  name: 'AzureFirewallSubnet'
}
resource managementSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  parent: vnet
  name: snMgmt
}
resource workloadsSubnet  'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  parent: vnet
  name: snWork
}

output vnetId string              = vnet.id
output firewallSubnetId string    = firewallSubnet.id
output managementSubnetId string  = managementSubnet.id
output workloadsSubnetId string   = workloadsSubnet.id
output vnetName string            = vnet.name
