targetScope = 'subscription'

@description('Names for policy assignments to display in Azure.')
param assignmentNames object = {
  allowedLocations: 'asg-allowed-locations'
  enforceTags: 'asg-enforce-tags'
  publicIpSku: 'asg-require-standard-publicip'
}

@description('Allowed Azure regions at subscription scope.')
param allowedLocations array = [
  'eastus2'
]

@description('Required tag keys enforced on all resources.')
param requiredTagKeys array = [
  'environment'
  'owner'
]

var defAllowedLocationsName = 'def-allowed-locations'
var defEnforceTagsName      = 'def-enforce-tags'
var defPublicIpSkuName      = 'def-require-standard-publicip'

// 1) Define policies
resource defAllowedLocations 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: defAllowedLocationsName
  properties: loadJsonContent('../policies/allowed-locations.json').properties
}

resource defEnforceTags 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: defEnforceTagsName
  properties: loadJsonContent('../policies/enforce-tags.json').properties
}

resource defPublicIpSku 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: defPublicIpSkuName
  properties: loadJsonContent('../policies/require-standard-publicip.json').properties
}

// 2) Assign policies at subscription scope
resource asgAllowedLocations 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: assignmentNames.allowedLocations
  properties: {
    displayName: 'Allowed locations (subscription)'
    scope: subscription().id
    policyDefinitionId: defAllowedLocations.id
    parameters: {
      listOfAllowedLocations: {
        value: allowedLocations
      }
    }
    enforcementMode: 'Default'
  }
}

resource asgEnforceTags 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: assignmentNames.enforceTags
  properties: {
    displayName: 'Enforce required tags'
    scope: subscription().id
    policyDefinitionId: defEnforceTags.id
    parameters: {
      requiredTagKeys: {
        value: requiredTagKeys
      }
    }
    enforcementMode: 'Default'
  }
}

resource asgPublicIpSku 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: assignmentNames.publicIpSku
  properties: {
    displayName: 'Public IPs must be Standard SKU'
    scope: subscription().id
    policyDefinitionId: defPublicIpSku.id
    enforcementMode: 'Default'
  }
}

output policyDefinitionIds object = {
  allowedLocations: defAllowedLocations.id
  enforceTags: defEnforceTags.id
  publicIpSku: defPublicIpSku.id
}

output policyAssignmentIds object = {
  allowedLocations: asgAllowedLocations.id
  enforceTags: asgEnforceTags.id
  publicIpSku: asgPublicIpSku.id
}
