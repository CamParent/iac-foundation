targetScope = 'subscription'

@description('Enable Defender for Cloud plan for AKS (KubernetesService).')
param enableDefender bool = true

// Enables the Defender for Cloud plan for AKS at subscription scope.
// Plan name: "KubernetesService"
resource defenderK8s 'Microsoft.Security/pricings@2023-01-01' = if (enableDefender) {
  name: 'KubernetesService'
  properties: {
    pricingTier: 'Standard' // Defender plan
  }
}

output defenderEnabled bool = enableDefender
