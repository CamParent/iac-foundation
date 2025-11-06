// RG-scoped VNet peering (create one peering from the local VNet to the remote VNet)
targetScope = 'resourceGroup'

@description('Name of the local VNet in this resource group.')
param localVnetName string

@description('Resource ID of the remote VNet (can be in another RG/sub).')
param remoteVnetId string

@description('Allow virtual network access.')
param allowVnetAccess bool = true

@description('Allow forwarded traffic.')
param allowForwardedTraffic bool = true

@description('Allow gateway transit (if local VNet has a gateway).')
param allowGatewayTransit bool = false

@description('Use remote gateways (if remote VNet has a gateway).')
param useRemoteGateways bool = false

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: localVnetName
}

resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: 'to-remote'
  parent: vnet
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
