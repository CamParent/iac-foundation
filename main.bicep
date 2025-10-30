param location string = 'eastus2'
param vnetId string = '/subscriptions/95f5b230-2ac0-46e4-9e78-213a57b19bda/resourceGroups/rg-hub-networking/providers/Microsoft.Network/virtualNetworks/vnet-hub'

module firewall './modules/firewall.bicep' = {
  name: 'firewall-module'
  params: {
    location: location
    vnetId: vnetId
  }
}
