param location string = 'eastus2'
param firewallName string = 'fw-hub-demo'
param publicIpName string = 'pip-fw-hub-demo'
param vnetId string
param subnetName string = 'AzureFirewallSubnet'

resource pip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIpName
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

resource firewall 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: firewallName
  location: location
  properties: {
    sku: { name: 'AZFW_VNet', tier: 'Standard' }
    ipConfigurations: [
      {
        name: 'configuration'
        properties: {
          subnet: { id: '${vnetId}/subnets/${subnetName}' }
          publicIPAddress: { id: pip.id }
        }
      }
    ]
  }
}
