param ApplicationGatewayWebApplicationFirewallPolicies_appgw_waf_policy_name string = 'appgw-waf-policy'
param applicationGateways_appgw_waf_name string = 'appgw-waf'
param networkInterfaces_vm_web_01535_z2_name string = 'vm-web-01535_z2'
param networkSecurityGroups_vm_web_01_nsg_name string = 'vm-web-01-nsg'
param privateDnsZones_privatelink_blob_core_windows_net_name string = 'privatelink.blob.core.windows.net'
param privateEndpoints_pe_storage_name string = 'pe-storage'
param publicIPAddresses_pip_appgw_name string = 'pip-appgw'
param publicIPAddresses_pip_vm_web_01_name string = 'pip-vm-web-01'
param routeTables_rt_spoke_egress_externalid string = '/subscriptions/95f5b230-2ac0-46e4-9e78-213a57b19bda/resourceGroups/rg-hub-networking/providers/Microsoft.Network/routeTables/rt-spoke-egress'
param storageAccounts_stappweb01_name string = 'stappweb01'
param virtualMachines_vm_web_01_name string = 'vm-web-01'
param virtualNetworks_vnet_app_name string = 'vnet-app'
param virtualNetworks_vnet_hub_externalid string = '/subscriptions/95f5b230-2ac0-46e4-9e78-213a57b19bda/resourceGroups/rg-hub-networking/providers/Microsoft.Network/virtualNetworks/vnet-hub'

resource ApplicationGatewayWebApplicationFirewallPolicies_appgw_waf_policy_name_resource 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2024-07-01' = {
  location: 'eastus2'
  name: ApplicationGatewayWebApplicationFirewallPolicies_appgw_waf_policy_name
  properties: {
    customRules: []
    managedRules: {
      exclusions: []
      managedRuleSets: [
        {
          ruleGroupOverrides: []
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
        }
      ]
    }
    policySettings: {
      fileUploadEnforcement: true
      fileUploadLimitInMb: 100
      maxRequestBodySizeInKb: 128
      mode: 'Prevention'
      requestBodyCheck: true
      requestBodyEnforcement: true
      requestBodyInspectLimitInKB: 128
      state: 'Enabled'
    }
  }
}

resource networkSecurityGroups_vm_web_01_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  location: 'eastus2'
  name: networkSecurityGroups_vm_web_01_nsg_name
  properties: {
    securityRules: [
      {
        id: networkSecurityGroups_vm_web_01_nsg_name_HTTP.id
        name: 'HTTP'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '80'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 300
          protocol: 'TCP'
          sourceAddressPrefix: '10.1.2.0/24'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        id: networkSecurityGroups_vm_web_01_nsg_name_Allow_SSH_MyIP.id
        name: 'Allow-SSH-MyIP'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '22'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 1000
          protocol: 'TCP'
          sourceAddressPrefix: '76.34.82.77'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
    ]
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  location: 'global'
  name: privateDnsZones_privatelink_blob_core_windows_net_name
  properties: {}
}

resource publicIPAddresses_pip_appgw_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  location: 'eastus2'
  name: publicIPAddresses_pip_appgw_name
  properties: {
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
    dnsSettings: {
      domainNameLabel: 'appgw-waf-demo'
      fqdn: 'appgw-waf-demo.eastus2.cloudapp.azure.com'
    }
    idleTimeoutInMinutes: 4
    ipAddress: '128.85.244.210'
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
    '3'
    '2'
  ]
}

resource publicIPAddresses_pip_vm_web_01_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  location: 'eastus2'
  name: publicIPAddresses_pip_vm_web_01_name
  properties: {
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
    idleTimeoutInMinutes: 4
    ipAddress: '128.24.106.181'
    ipTags: []
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
}

resource storageAccounts_stappweb01_name_resource 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  kind: 'StorageV2'
  location: 'eastus2'
  name: storageAccounts_stappweb01_name
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: true
    defaultToOAuthAuthentication: false
    dnsEndpointType: 'Standard'
    encryption: {
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: false
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
    largeFileSharesState: 'Enabled'
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    publicNetworkAccess: 'Disabled'
    supportsHttpsTrafficOnly: true
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource virtualMachines_vm_web_01_name_resource 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  location: 'eastus2'
  name: virtualMachines_vm_web_01_name
  properties: {
    additionalCapabilities: {
      hibernationEnabled: false
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_web_01535_z2_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    osProfile: {
      adminUsername: 'CamParent'
      allowExtensionOperations: true
      computerName: virtualMachines_vm_web_01_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        patchSettings: {
          assessmentMode: 'ImageDefault'
          patchMode: 'ImageDefault'
        }
        provisionVMAgent: true
      }
      requireGuestProvisionSignal: true
      secrets: []
    }
    securityProfile: {
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }
    storageProfile: {
      dataDisks: []
      diskControllerType: 'SCSI'
      imageReference: {
        offer: 'ubuntu-24_04-lts'
        publisher: 'canonical'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        caching: 'ReadWrite'
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_web_01_name}_OsDisk_1_89e7615efc594c79af764c3b9796cb49'
          )
        }
        name: '${virtualMachines_vm_web_01_name}_OsDisk_1_89e7615efc594c79af764c3b9796cb49'
        osType: 'Linux'
      }
    }
  }
  zones: [
    '2'
  ]
}

resource networkSecurityGroups_vm_web_01_nsg_name_Allow_SSH_MyIP 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_vm_web_01_nsg_name}/Allow-SSH-MyIP'
  properties: {
    access: 'Allow'
    destinationAddressPrefix: '*'
    destinationAddressPrefixes: []
    destinationPortRange: '22'
    destinationPortRanges: []
    direction: 'Inbound'
    priority: 1000
    protocol: 'TCP'
    sourceAddressPrefix: '76.34.82.77'
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
  dependsOn: [
    networkSecurityGroups_vm_web_01_nsg_name_resource
  ]
}

resource networkSecurityGroups_vm_web_01_nsg_name_HTTP 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_vm_web_01_nsg_name}/HTTP'
  properties: {
    access: 'Allow'
    destinationAddressPrefix: '*'
    destinationAddressPrefixes: []
    destinationPortRange: '80'
    destinationPortRanges: []
    direction: 'Inbound'
    priority: 300
    protocol: 'TCP'
    sourceAddressPrefix: '10.1.2.0/24'
    sourceAddressPrefixes: []
    sourcePortRange: '*'
    sourcePortRanges: []
  }
  dependsOn: [
    networkSecurityGroups_vm_web_01_nsg_name_resource
  ]
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_stappweb01 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'stappweb01'
  properties: {
    aRecords: [
      {
        ipv4Address: '10.1.1.5'
      }
    ]
    ttl: 3600
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_blob_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: '@'
  properties: {
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
    ttl: 3600
  }
}

resource virtualNetworks_vnet_app_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  location: 'eastus2'
  name: virtualNetworks_vnet_app_name
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
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
        id: virtualNetworks_vnet_app_name_appgw_subbet.id
        name: 'appgw-subbet'
        properties: {
          addressPrefixes: [
            '10.1.2.0/24'
          ]
          applicationGatewayIPConfigurations: [
            {
              id: '${applicationGateways_appgw_waf_name_resource.id}/gatewayIPConfigurations/appGatewayIpConfig'
            }
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        id: virtualNetworks_vnet_app_name_app_subnet.id
        name: 'app-subnet'
        properties: {
          addressPrefixes: [
            '10.1.1.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          routeTable: {
            id: routeTables_rt_spoke_egress_externalid
          }
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        id: virtualNetworks_vnet_app_name_virtualNetworks_vnet_app_name_to_hub.id
        name: '${virtualNetworks_vnet_app_name}-to-hub'
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
              '10.0.0.0/16'
            ]
          }
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_hub_externalid
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
          useRemoteGateways: false
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
  }
}

resource virtualNetworks_vnet_app_name_app_subnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_vnet_app_name}/app-subnet'
  properties: {
    addressPrefixes: [
      '10.1.1.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    routeTable: {
      id: routeTables_rt_spoke_egress_externalid
    }
  }
  dependsOn: [
    virtualNetworks_vnet_app_name_resource
  ]
}

resource virtualNetworks_vnet_app_name_virtualNetworks_vnet_app_name_to_hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-07-01' = {
  name: '${virtualNetworks_vnet_app_name}/${virtualNetworks_vnet_app_name}-to-hub'
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
        '10.0.0.0/16'
      ]
    }
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_hub_externalid
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    useRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_vnet_app_name_resource
  ]
}

resource storageAccounts_stappweb01_name_default 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  parent: storageAccounts_stappweb01_name_resource
  name: 'default'
  properties: {
    containerDeleteRetentionPolicy: {
      days: 7
      enabled: true
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      days: 7
      enabled: true
    }
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_stappweb01_name_default 'Microsoft.Storage/storageAccounts/fileServices@2025-01-01' = {
  parent: storageAccounts_stappweb01_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    protocolSettings: {
      smb: {}
    }
    shareDeleteRetentionPolicy: {
      days: 7
      enabled: true
    }
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource storageAccounts_stappweb01_name_storageAccounts_stappweb01_name_f9c037e5_91a9_4142_b983_ccb0eacf9014 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2025-01-01' = {
  parent: storageAccounts_stappweb01_name_resource
  name: '${storageAccounts_stappweb01_name}.f9c037e5-91a9-4142-b983-ccb0eacf9014'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      actionRequired: 'None'
      description: 'Auto-Approved'
      status: 'Approved'
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_stappweb01_name_default 'Microsoft.Storage/storageAccounts/queueServices@2025-01-01' = {
  parent: storageAccounts_stappweb01_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_stappweb01_name_default 'Microsoft.Storage/storageAccounts/tableServices@2025-01-01' = {
  parent: storageAccounts_stappweb01_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource networkInterfaces_vm_web_01535_z2_name_resource 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  kind: 'Regular'
  location: 'eastus2'
  name: networkInterfaces_vm_web_01535_z2_name
  properties: {
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
    disableTcpStateTracking: false
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    ipConfigurations: [
      {
        id: '${networkInterfaces_vm_web_01535_z2_name_resource.id}/ipConfigurations/ipconfig1'
        name: 'ipconfig1'
        properties: {
          primary: true
          privateIPAddress: '10.1.1.4'
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet_app_name_app_subnet.id
          }
        }
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_vm_web_01_nsg_name_resource.id
    }
    nicType: 'Standard'
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_jhsuu2fwlegi6 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  location: 'global'
  name: 'jhsuu2fwlegi6'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_vnet_app_name_resource.id
    }
  }
}

resource privateEndpoints_pe_storage_name_resource 'Microsoft.Network/privateEndpoints@2024-07-01' = {
  location: 'eastus2'
  name: privateEndpoints_pe_storage_name
  properties: {
    customDnsConfigs: [
      {
        fqdn: 'stappweb01.blob.core.windows.net'
        ipAddresses: [
          '10.1.1.5'
        ]
      }
    ]
    ipConfigurations: []
    manualPrivateLinkServiceConnections: []
    privateLinkServiceConnections: [
      {
        id: '${privateEndpoints_pe_storage_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_pe_storage_name}_9d8c3faa-0fd1-4895-9595-179aa1c46028'
        name: '${privateEndpoints_pe_storage_name}_9d8c3faa-0fd1-4895-9595-179aa1c46028'
        properties: {
          groupIds: [
            'blob'
          ]
          privateLinkServiceConnectionState: {
            actionsRequired: 'None'
            description: 'Auto-Approved'
            status: 'Approved'
          }
          privateLinkServiceId: storageAccounts_stappweb01_name_resource.id
        }
      }
    ]
    subnet: {
      id: virtualNetworks_vnet_app_name_app_subnet.id
    }
  }
}

resource virtualNetworks_vnet_app_name_appgw_subbet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_vnet_app_name}/appgw-subbet'
  properties: {
    addressPrefixes: [
      '10.1.2.0/24'
    ]
    applicationGatewayIPConfigurations: [
      {
        id: '${applicationGateways_appgw_waf_name_resource.id}/gatewayIPConfigurations/appGatewayIpConfig'
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_app_name_resource
  ]
}

resource storageAccounts_stappweb01_name_default_webdata 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' = {
  parent: storageAccounts_stappweb01_name_default
  name: 'webdata'
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    immutableStorageWithVersioning: {
      enabled: false
    }
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_stappweb01_name_resource
  ]
}

resource applicationGateways_appgw_waf_name_resource 'Microsoft.Network/applicationGateways@2024-07-01' = {
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/95f5b230-2ac0-46e4-9e78-213a57b19bda/resourcegroups/rg-shared-services/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-appgw': {}
    }
  }
  location: 'eastus2'
  name: applicationGateways_appgw_waf_name
  properties: {
    autoscaleConfiguration: {
      maxCapacity: 10
      minCapacity: 0
    }
    backendAddressPools: [
      {
        id: '${applicationGateways_appgw_waf_name_resource.id}/backendAddressPools/pool-vm-web'
        name: 'pool-vm-web'
        properties: {
          backendAddresses: [
            {
              ipAddress: '10.1.1.4'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        id: '${applicationGateways_appgw_waf_name_resource.id}/backendHttpSettingsCollection/bep-https-80'
        name: 'bep-https-80'
        properties: {
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          port: 80
          protocol: 'Http'
          requestTimeout: 20
        }
      }
    ]
    backendSettingsCollection: []
    enableFips: false
    enableHttp2: true
    firewallPolicy: {
      id: ApplicationGatewayWebApplicationFirewallPolicies_appgw_waf_policy_name_resource.id
    }
    forceFirewallPolicyAssociation: true
    frontendIPConfigurations: [
      {
        id: '${applicationGateways_appgw_waf_name_resource.id}/frontendIPConfigurations/appGwPublicFrontendIpIPv4'
        name: 'appGwPublicFrontendIpIPv4'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pip_appgw_name_resource.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        id: '${applicationGateways_appgw_waf_name_resource.id}/frontendPorts/port_443'
        name: 'port_443'
        properties: {
          port: 443
        }
      }
    ]
    gatewayIPConfigurations: [
      {
        id: '${applicationGateways_appgw_waf_name_resource.id}/gatewayIPConfigurations/appGatewayIpConfig'
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: virtualNetworks_vnet_app_name_appgw_subbet.id
          }
        }
      }
    ]
    httpListeners: [
      {
        id: '${applicationGateways_appgw_waf_name_resource.id}/httpListeners/listener-https'
        name: 'listener-https'
        properties: {
          customErrorConfigurations: []
          frontendIPConfiguration: {
            id: '${applicationGateways_appgw_waf_name_resource.id}/frontendIPConfigurations/appGwPublicFrontendIpIPv4'
          }
          frontendPort: {
            id: '${applicationGateways_appgw_waf_name_resource.id}/frontendPorts/port_443'
          }
          hostNames: []
          protocol: 'Https'
          requireServerNameIndication: false
          sslCertificate: {
            id: '${applicationGateways_appgw_waf_name_resource.id}/sslCertificates/app-internal-local'
          }
        }
      }
    ]
    listeners: []
    loadDistributionPolicies: []
    privateLinkConfigurations: []
    probes: []
    redirectConfigurations: []
    requestRoutingRules: [
      {
        id: '${applicationGateways_appgw_waf_name_resource.id}/requestRoutingRules/rule-https-to-vm'
        name: 'rule-https-to-vm'
        properties: {
          backendAddressPool: {
            id: '${applicationGateways_appgw_waf_name_resource.id}/backendAddressPools/pool-vm-web'
          }
          backendHttpSettings: {
            id: '${applicationGateways_appgw_waf_name_resource.id}/backendHttpSettingsCollection/bep-https-80'
          }
          httpListener: {
            id: '${applicationGateways_appgw_waf_name_resource.id}/httpListeners/listener-https'
          }
          priority: 100
          ruleType: 'Basic'
        }
      }
    ]
    rewriteRuleSets: []
    routingRules: []
    sku: {
      family: 'Generation_1'
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }
    sslCertificates: [
      {
        id: '${applicationGateways_appgw_waf_name_resource.id}/sslCertificates/app-internal-local'
        name: 'app-internal-local'
        properties: {
          keyVaultSecretId: 'https://kv-cert-store-615.vault.azure.net/secrets/app-internal-local'
        }
      }
    ]
    sslProfiles: []
    trustedClientCertificates: []
    trustedRootCertificates: []
    urlPathMaps: []
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}
