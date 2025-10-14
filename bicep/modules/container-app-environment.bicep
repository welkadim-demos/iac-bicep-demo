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

@description('Application Insights instrumentation key for Dapr telemetry')
@secure()
param daprAIInstrumentationKey string = ''

@description('Application Insights connection string for Dapr telemetry')
@secure()
param daprAIConnectionString string = ''

@description('Name of the infrastructure resource group (optional)')
param infrastructureResourceGroup string = ''

@description('Virtual network configuration')
param vnetConfiguration object = {}

@description('Workload profiles for the environment')
param workloadProfiles array = []

@description('Whether to enable mTLS authentication')
param mtlsEnabled bool = false

@description('Whether to enable peer traffic encryption')
param peerTrafficEncryptionEnabled bool = false

@description('Custom domain configuration')
param customDomainConfiguration object = {}

@description('Tags to apply to the Container App Environment')
param tags object = {}

// Container App Environment resource
resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
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
    } : {
      destination: 'none'
    }
    daprAIInstrumentationKey: !empty(daprAIInstrumentationKey) ? daprAIInstrumentationKey : null
    daprAIConnectionString: !empty(daprAIConnectionString) ? daprAIConnectionString : null
    workloadProfiles: !empty(workloadProfiles) ? workloadProfiles : null
    peerAuthentication: mtlsEnabled ? {
      mtls: {
        enabled: mtlsEnabled
      }
    } : null
    peerTrafficConfiguration: peerTrafficEncryptionEnabled ? {
      encryption: {
        enabled: peerTrafficEncryptionEnabled
      }
    } : null
    customDomainConfiguration: !empty(customDomainConfiguration) ? customDomainConfiguration : null
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

@description('The infrastructure resource group name')
output infrastructureResourceGroupName string = containerAppEnvironment.properties.infrastructureResourceGroup

@description('The custom domain verification ID')
output customDomainVerificationId string = !empty(customDomainConfiguration) ? containerAppEnvironment.properties.customDomainConfiguration.customDomainVerificationId : ''
