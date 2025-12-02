@description('Azure region for the AKS cluster.')
param location string

@description('AKS cluster name.')
param aksName string

@description('Subnet ID for the AKS node pool.')
param aksSubnetId string

@description('Object IDs of Azure AD groups that should be cluster admins (Azure RBAC).')
param adminGroupObjectIds array = []

@description('Tags to apply to the AKS cluster.')
param tags object = {}

@description('Log Analytics workspace resource ID')
param logAnalyticsWorkspaceId string

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: tags
  sku: {
    name: 'Base'
    tier: 'Standard'
  }
    properties: {
    dnsPrefix: '${aksName}-dns'

    enableRBAC: true

    azureMonitorProfile: {
      metrics: {
        enabled: true
      }
    }

    securityProfile: {
      defender: {
        logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceId
        securityMonitoring: {
          enabled: true
        }
      }
      workloadIdentity: {
        enabled: true
      }
    }

    oidcIssuerProfile: {
      enabled: true
    }

    aadProfile: {
      managed: true
      enableAzureRBAC: true
      adminGroupObjectIDs: adminGroupObjectIds
    }

    apiServerAccessProfile: {
      enablePrivateCluster: true
    }

    networkProfile: {
      networkPlugin: 'azure'
      networkPluginMode: 'overlay'
      networkDataplane: 'cilium'

      podCidr: '10.10.0.0/16'
      serviceCidr: '10.11.0.0/16'
      dnsServiceIP: '10.11.0.10'

      loadBalancerSku: 'standard'
      outboundType: 'loadBalancer'
    }

    agentPoolProfiles: [
      {
        name: 'systemnp'
        mode: 'System'
        count: 1
        vmSize: 'Standard_B2s'
        osType: 'Linux'
        osSKU: 'Ubuntu'
        vnetSubnetID: aksSubnetId
        enableAutoScaling: true
        minCount: 1
        maxCount: 1
      }
    ]
  }
}

resource aksDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'aks-to-law-sec-ops'
  scope: aks
  properties: {
    workspaceId: logAnalyticsWorkspaceId

    logs: [
      {
        category: 'kube-apiserver'
        enabled: true
      }
      {
        category: 'kube-controller-manager'
        enabled: true
      }
      {
        category: 'kube-scheduler'
        enabled: true
      }
      {
        category: 'cluster-autoscaler'
        enabled: true
      }
      {
        category: 'kube-audit'
        enabled: true
      }
      {
        category: 'kube-audit-admin'
        enabled: true
      }
    ]

    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output aksNameOut string       = aks.name
output aksPrincipalId string   = aks.identity.principalId
output aksFqdn string          = aks.properties.fqdn
