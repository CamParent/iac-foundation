targetScope = 'subscription'

@description('Allowed Azure regions for deployments.')
param allowedLocations array = [
  'eastus2'
]

//
// 1) Allowed Locations Policy (Custom)
//
resource defAllowedLocations 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'custom-allowed-locations'
  properties: {
    displayName: 'Allowed locations (subscription)'
    description: 'Restricts deployments to a set of approved regions.'
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: 'General'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'location'
            // Bicep param gets serialized directly as the array value
            notIn: allowedLocations
          }
          {
            field: 'location'
            notEquals: 'global'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

//
// 2) Require Standard SKU Public IPs
//
resource defRequireStdPip 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'custom-require-standard-publicip'
  properties: {
    displayName: 'Public IPs must use Standard SKU'
    description: 'Audits Public IP resources that are not using Standard SKU.'
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'Networking'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Network/publicIPAddresses'
          }
          {
            field: 'Microsoft.Network/publicIPAddresses/sku.name'
            notEquals: 'Standard'
          }
        ]
      }
      then: {
        effect: 'audit'
      }
    }
  }
}

//
// 3) AKS: Audit non-private API server
//
resource defAksPrivateCluster 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'custom-aks-audit-not-private'
  properties: {
    displayName: 'Audit AKS clusters without private API server'
    description: 'Audits AKS clusters where apiServerAccessProfile.enablePrivateCluster is not enabled.'
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'Kubernetes'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.ContainerService/managedClusters'
          }
          {
            field: 'Microsoft.ContainerService/managedClusters/apiServerAccessProfile.enablePrivateCluster'
            notEquals: true
          }
        ]
      }
      then: {
        effect: 'audit'
      }
    }
  }
}

//
// 4) AKS: Audit clusters without RBAC enabled
//
resource defAksRbacEnabled 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'custom-aks-audit-no-rbac'
  properties: {
    displayName: 'Audit AKS clusters without Kubernetes RBAC enabled'
    description: 'Audits AKS clusters where enableRBAC is false.'
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'Kubernetes'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.ContainerService/managedClusters'
          }
          {
            field: 'Microsoft.ContainerService/managedClusters/enableRBAC'
            equals: false
          }
        ]
      }
      then: {
        effect: 'audit'
      }
    }
  }
}

//
// Assignments (subscription scope)
//

// Allowed locations assignment
resource asgAllowedLocations 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'asg-allowed-locations'
  properties: {
    displayName: 'Allowed locations (subscription)'
    policyDefinitionId: defAllowedLocations.id
    enforcementMode: 'Default'
  }
}

// Require Standard SKU Public IPs
resource asgRequireStdPip 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'asg-require-standard-publicip'
  properties: {
    displayName: 'Public IPs must be Standard SKU'
    policyDefinitionId: defRequireStdPip.id
    enforcementMode: 'Default'
  }
}

// AKS: Private API server audit
resource asgAksPrivateCluster 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'asg-aks-audit-not-private'
  properties: {
    displayName: 'AKS clusters should use private API server'
    policyDefinitionId: defAksPrivateCluster.id
    enforcementMode: 'Default'
  }
}

// AKS: RBAC audit
resource asgAksRbacEnabled 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'asg-aks-audit-no-rbac'
  properties: {
    displayName: 'AKS clusters should have Kubernetes RBAC enabled'
    policyDefinitionId: defAksRbacEnabled.id
    enforcementMode: 'Default'
  }
}

// Optional: expose parameters to outer template
output allowedLocationsAssigned array = allowedLocations
