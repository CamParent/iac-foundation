@description('Azure region')
param location string
@description('Name prefix for spoke resources, e.g. "spoke-app" -> vnet-spoke-app')
param namePrefix string
@description('Spoke VNet address space, e.g. "10.2.0.0/16"')
param addressSpace string
@description('Subnet prefix for the app/web tier, e.g. "10.2.1.0/24"')
param appSubnetPrefix string
@description('Optional tags')
param tags object = {}

var vnetName = 'vnet-${namePrefix}'
var snApp    = 'sn-${namePrefix}-app'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: [ addressSpace ] }
    subnets: [
      { name: snApp, properties: { addressPrefix: appSubnetPrefix } }
    ]
  }
}

resource appSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  parent: vnet
  name: snApp
}

output vnetId string      = vnet.id
output appSubnetId string = appSubnet.id
output vnetName string    = vnet.name
