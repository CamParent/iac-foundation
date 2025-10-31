using '../main.bicep'

param namePrefix       = 'cam'
param location         = 'eastus2'

param hubRgName        = 'rg-hub-networking'
param spokeRgName      = 'rg-spoke-app'
param sharedRgName     = 'rg-shared-services'

param hubAddressSpace  = [
  '10.1.0.0/16'
]
param spokeAddressSpace = [
  '10.2.0.0/16'
]
param appSubnetPrefix  = '10.2.1.0/24'

param firewallSku      = 'Standard'

param tags = {
  environment: 'dev'
  workload: 'foundation'
  owner: 'cam'
}
