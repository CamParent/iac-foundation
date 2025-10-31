targetScope = 'resourceGroup'

@description('Local VNet name in THIS resource group.')
param localVnetName string

@description('Remote VNet resource ID (can be in another RG/sub).')
param remoteVnetId string

@description('Enable virtual network access')
param allowVnetAccess bool = true

@description('Allow forwarded traffic (for hub firewall/NVA transit)')
param allowForwardedTraffic bool = true

@description('Advertise this VNet’s gateway to remote (set true on the side with the gateway)')
param allowGatewayTransit bool = false

@description('Use remote gateway (set true only on the spoke side)')
param useRemoteGateways bool = false

resource localVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: localVnetName
}

resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  // IMPORTANT: single quotes only in Bicep
  name: 'to-${last(split(remoteVnetId, '/'))}'
  parent: localVnet
  properties: {
    allowVirtualNetworkAccess: allowVnetAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: remoteVnetId
    }
  }
}

output peeringId string = vnetPeering.id
