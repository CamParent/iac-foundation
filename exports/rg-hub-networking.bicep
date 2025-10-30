param azureFirewalls_fw_hub_name string = 'fw-hub'
param publicIPAddresses_pip_fw_hub_name string = 'pip-fw-hub'
param routeTables_rt_spoke_egress_name string = 'rt-spoke-egress'
param virtualNetworks_vnet_app_externalid string = '/subscriptions/95f5b230-2ac0-46e4-9e78-213a57b19bda/resourceGroups/rg-spoke-app/providers/Microsoft.Network/virtualNetworks/vnet-app'
param virtualNetworks_vnet_hub_name string = 'vnet-hub'

resource publicIPAddresses_pip_fw_hub_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  location: 'eastus2'
  name: publicIPAddresses_pip_fw_hub_name
  properties: {
    idleTimeoutInMinutes: 4
    ipAddress: '68.220.16.147'
    ipTags: []
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

resource routeTables_rt_spoke_egress_name_resource 'Microsoft.Network/routeTables@2024-07-01' = {
  location: 'eastus2'
  name: routeTables_rt_spoke_egress_name
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        id: routeTables_rt_spoke_egress_name_Default.id
        name: 'Default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: '10.0.1.4'
          nextHopType: 'VirtualAppliance'
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
    ]
  }
}

resource virtualNetworks_vnet_hub_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  location: 'eastus2'
  name: virtualNetworks_vnet_hub_name
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    enableDdosProtection: false
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        id: virtualNetworks_vnet_hub_name_AzureFirewallSubnet.id
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefixes: [
            '10.0.1.0/26'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        id: virtualNetworks_vnet_hub_name_GatewaySubnet.id
        name: 'GatewaySubnet'
        properties: {
          addressPrefixes: [
            '10.0.2.0/27'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        id: virtualNetworks_vnet_hub_name_AzureFirewallManagementSubnet.id
        name: 'AzureFirewallManagementSubnet'
        properties: {
          addressPrefixes: [
            '10.0.3.0/26'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        id: virtualNetworks_vnet_hub_name_virtualNetworks_vnet_hub_name_to_app.id
        name: '${virtualNetworks_vnet_hub_name}-to-app'
        properties: {
          allowForwardedTraffic: true
          allowGatewayTransit: false
          allowVirtualNetworkAccess: true
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteAddressSpace: {
            addressPrefixes: [
              '10.1.0.0/16'
            ]
          }
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_app_externalid
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.1.0.0/16'
            ]
          }
          useRemoteGateways: false
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
  }
}

resource routeTables_rt_spoke_egress_name_Default 'Microsoft.Network/routeTables/routes@2024-07-01' = {
  name: '${routeTables_rt_spoke_egress_name}/Default'
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopIpAddress: '10.0.1.4'
    nextHopType: 'VirtualAppliance'
  }
  dependsOn: [
    routeTables_rt_spoke_egress_name_resource
  ]
}

resource virtualNetworks_vnet_hub_name_AzureFirewallManagementSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_vnet_hub_name}/AzureFirewallManagementSubnet'
  properties: {
    addressPrefixes: [
      '10.0.3.0/26'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_hub_name_resource
  ]
}

resource virtualNetworks_vnet_hub_name_AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_vnet_hub_name}/AzureFirewallSubnet'
  properties: {
    addressPrefixes: [
      '10.0.1.0/26'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_hub_name_resource
  ]
}

resource virtualNetworks_vnet_hub_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_vnet_hub_name}/GatewaySubnet'
  properties: {
    addressPrefixes: [
      '10.0.2.0/27'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_hub_name_resource
  ]
}

resource virtualNetworks_vnet_hub_name_virtualNetworks_vnet_hub_name_to_app 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-07-01' = {
  name: '${virtualNetworks_vnet_hub_name}/${virtualNetworks_vnet_hub_name}-to-app'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteAddressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_app_externalid
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    useRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_vnet_hub_name_resource
  ]
}

resource azureFirewalls_fw_hub_name_resource 'Microsoft.Network/azureFirewalls@2024-07-01' = {
  location: 'eastus2'
  name: azureFirewalls_fw_hub_name
  properties: {
    additionalProperties: {}
    applicationRuleCollections: [
      {
        id: '${azureFirewalls_fw_hub_name_resource.id}/applicationRuleCollections/allow-web-out'
        name: 'allow-web-out'
        properties: {
          action: {
            type: 'Allow'
          }
          priority: 200
          rules: [
            {
              fqdnTags: []
              name: 'apt-web-out'
              protocols: [
                {
                  port: 80
                  protocolType: 'Http'
                }
                {
                  port: 443
                  protocolType: 'Https'
                }
              ]
              sourceAddresses: [
                '10.1.1.0/24'
              ]
              sourceIpGroups: []
              targetFqdns: [
                'archive.ubuntu.com'
                '*.ubuntu.com'
                '*.microsoft.com'
                '*.debian.org'
              ]
            }
          ]
        }
      }
      {
        id: '${azureFirewalls_fw_hub_name_resource.id}/applicationRuleCollections/allow-azure-auth'
        name: 'allow-azure-auth'
        properties: {
          action: {
            type: 'Allow'
          }
          priority: 150
          rules: [
            {
              fqdnTags: []
              name: 'allow-azure-auth'
              protocols: [
                {
                  port: 443
                  protocolType: 'Https'
                }
              ]
              sourceAddresses: [
                '10.1.1.0/24'
              ]
              sourceIpGroups: []
              targetFqdns: [
                'login.microsoftonline.com'
                'login.windows.net'
                'device.login.microsoftonline.com'
                'aadcdn.msftauth.net'
                '*.msauth.ne'
                '*.msftauth.net'
                'management.azure.com'
                '*.microsoftonline.com'
                '*.microsoft.com'
                'ocsp.msocsp.com'
                'ocsp.digicert.com'
                'crl3.digicert.com'
                'crl4.digicert.com'
                'www.msftconnecttest.com'
              ]
            }
          ]
        }
      }
      {
        id: '${azureFirewalls_fw_hub_name_resource.id}/applicationRuleCollections/allow-appgw-fqdn'
        name: 'allow-appgw-fqdn'
        properties: {
          action: {
            type: 'Allow'
          }
          priority: 140
          rules: [
            {
              fqdnTags: []
              name: 'allow-appgw-fqdn'
              protocols: [
                {
                  port: 443
                  protocolType: 'Https'
                }
              ]
              sourceAddresses: [
                '10.1.1.0/24'
              ]
              sourceIpGroups: []
              targetFqdns: [
                'appgw-waf-demo.eastus2.cloudapp.azure.com'
              ]
            }
          ]
        }
      }
    ]
    ipConfigurations: [
      {
        id: '${azureFirewalls_fw_hub_name_resource.id}/azureFirewallIpConfigurations/pip-${azureFirewalls_fw_hub_name}'
        name: 'pip-${azureFirewalls_fw_hub_name}'
        properties: {
          publicIPAddress: {
            id: publicIPAddresses_pip_fw_hub_name_resource.id
          }
          subnet: {
            id: virtualNetworks_vnet_hub_name_AzureFirewallSubnet.id
          }
        }
      }
    ]
    natRuleCollections: []
    networkRuleCollections: [
      {
        id: '${azureFirewalls_fw_hub_name_resource.id}/networkRuleCollections/allow-dns-out'
        name: 'allow-dns-out'
        properties: {
          action: {
            type: 'Allow'
          }
          priority: 100
          rules: [
            {
              destinationAddresses: [
                '*'
              ]
              destinationFqdns: []
              destinationIpGroups: []
              destinationPorts: [
                '53'
              ]
              name: 'dns-out-any'
              protocols: [
                'UDP'
              ]
              sourceAddresses: [
                '10.1.1.0/24'
              ]
              sourceIpGroups: []
            }
          ]
        }
      }
    ]
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    threatIntelMode: 'Deny'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}
