@description('Region for resources')
param location string

@description('Name prefix for resources')
param namePrefix string

@description('Hub VNet address spaces')
param hubAddressSpace array

@description('AzureFirewallSubnet prefix')
param firewallSubnetPrefix string

@description('Workloads subnet prefix')
param workloadsSubnetPrefix string

@description('Common tags')
param tags object

// VNet
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: '${namePrefix}-hub-vnet'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: hubAddressSpace
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: firewallSubnetPrefix
        }
      }
      {
        name: 'workloads'
        properties: {
          addressPrefix: workloadsSubnetPrefix
        }
      }
    ]
  }
}

// Declare subnets as existing (so you can output their IDs)
resource afwSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  parent: hubVnet
  name: 'AzureFirewallSubnet'
}

resource workloadsSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  parent: hubVnet
  name: 'workloads'
}

output hubVnetId string = hubVnet.id
output firewallSubnetId string = afwSubnet.id
output workloadsSubnetId string = workloadsSubnet.id
