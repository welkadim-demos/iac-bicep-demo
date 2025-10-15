// Azure Container App Environment module
// Creates an Azure Container App Environment for hosting containerized applications

@description('The name of the Container App Environment')
param containerAppEnvironmentName string

@description('The location where the Container App Environment will be deployed')
param location string = resourceGroup().location

@description('Whether the environment should be zone-redundant')
param zoneRedundant bool = false

@description('Whether the environment should be internal (no public load balancer)')
param internal bool = false

@description('Log Analytics workspace customer ID for logging')
param logAnalyticsCustomerId string = ''

@description('Log Analytics workspace shared key for logging')
@secure()
param logAnalyticsSharedKey string = ''



@description('Name of the infrastructure resource group (optional)')
param infrastructureResourceGroup string = ''

@description('Virtual network configuration')
param vnetConfiguration object = {}

@description('Whether to enable Dapr for microservices')
param daprEnabled bool = false

@description('Custom domain configuration')
param customDomainConfiguration object = {}

@description('Tags to apply to the Container App Environment')
param tags object = {}

// Container App Environment resource
resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2025-01-01' = {
  name: containerAppEnvironmentName
  location: location
  tags: tags
  properties: {
    zoneRedundant: zoneRedundant
    infrastructureResourceGroup: !empty(infrastructureResourceGroup) ? infrastructureResourceGroup : null
    vnetConfiguration: !empty(vnetConfiguration) ? {
      internal: internal
      infrastructureSubnetId: vnetConfiguration.?infrastructureSubnetId
      dockerBridgeCidr: vnetConfiguration.?dockerBridgeCidr
      platformReservedCidr: vnetConfiguration.?platformReservedCidr
      platformReservedDnsIP: vnetConfiguration.?platformReservedDnsIP
    } : null
    appLogsConfiguration: !empty(logAnalyticsCustomerId) && !empty(logAnalyticsSharedKey) ? {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsCustomerId
        sharedKey: logAnalyticsSharedKey
      }
    } : null
    daprConfiguration: daprEnabled ? {} : null
  }
}

// Outputs
@description('The resource ID of the Container App Environment')
output containerAppEnvironmentId string = containerAppEnvironment.id

@description('The name of the Container App Environment')
output containerAppEnvironmentName string = containerAppEnvironment.name

@description('The location of the Container App Environment')
output containerAppEnvironmentLocation string = containerAppEnvironment.location

@description('The default domain of the Container App Environment')
output defaultDomain string = containerAppEnvironment.properties.defaultDomain

@description('The static IP address of the Container App Environment')
output staticIp string = containerAppEnvironment.properties.staticIp

@description('The provisioning state of the Container App Environment')
output provisioningState string = containerAppEnvironment.properties.provisioningState

@description('The event stream endpoint of the Container App Environment')
output eventStreamEndpoint string = containerAppEnvironment.properties.eventStreamEndpoint

@description('The custom domain verification ID')
output customDomainVerificationId string = !empty(customDomainConfiguration) ? containerAppEnvironment.properties.customDomainConfiguration.customDomainVerificationId : ''
