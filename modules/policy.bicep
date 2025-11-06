targetScope = 'subscription'

@description('Allowed Azure regions for deployments.')
param allowedLocations array = [
  'eastus2'
]

@description('Required tag keys for all resources.')
param requiredTagKeys array = [
  'environment'
  'owner'
]

// Load your existing JSON files (paths are from /modules)
var allowedJson   = json(loadTextContent('../policies/allowed-locations.json'))
var enforceJson   = json(loadTextContent('../policies/enforce-tags.json'))
var stdPipJson    = json(loadTextContent('../policies/require-standard-publicip.json'))

/* =========================
   Policy Definitions
   ========================= */
resource defAllowed 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'def-allowed-locations'
  properties: allowedJson.properties
}

resource defEnforceTags 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'def-enforce-tags'
  properties: enforceJson.properties
}

resource defRequireStdPip 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'def-require-standard-publicip'
  properties: stdPipJson.properties
}

/* =========================
   Assignments (subscription)
   ========================= */
resource asgAllowed 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'asg-allowed-locations'
  properties: {
    displayName: 'Allowed locations (subscription)'
    policyDefinitionId: defAllowed.id
    enforcementMode: 'Default'
    parameters: {
      listOfAllowedLocations: { value: allowedLocations }
    }
  }
}

resource asgEnforceTags 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'asg-enforce-tags'
  properties: {
    displayName: 'Enforce required tags'
    policyDefinitionId: defEnforceTags.id
    enforcementMode: 'Default'
    parameters: {
      requiredTagKeys: { value: requiredTagKeys }
    }
  }
}

resource asgRequireStdPip 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'asg-require-standard-publicip'
  properties: {
    displayName: 'Public IPs must be Standard SKU'
    policyDefinitionId: defRequireStdPip.id
    enforcementMode: 'Default'
  }
}

output allowedLocationsAssigned array = allowedLocations
output requiredTags array = requiredTagKeys
