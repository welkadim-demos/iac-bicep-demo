@description('The Azure region where resources will be deployed')
param location string = resourceGroup().location

@description('Environment name (dev, staging, prod)')
@allowed(['dev', 'staging', 'prod'])
param environment string = 'dev'

@description('Project name prefix for resource naming')
param projectName string = 'myproject'

@description('Location for Azure Bot Service (must be global, westeurope, westus, or centralindia)')
@allowed(['global', 'westeurope', 'westus', 'centralindia'])
param botServiceLocation string = 'global'

@description('Storage Account name (3-24 chars, lowercase letters and numbers only)')
@minLength(3)
@maxLength(24)
param storageAccountName string = 'st${replace('${projectName}${environment}', '-', '')}${uniqueString(resourceGroup().id)}'

@description('Azure AI Search service name (2-60 chars, lowercase letters, numbers, hyphens)')
@minLength(2)
@maxLength(60)
param searchServiceName string = 'srch-${projectName}-${environment}-${uniqueString(resourceGroup().id)}'

@description('AI Foundry service name (2-64 chars, alphanumeric, hyphens)')
@minLength(2)
@maxLength(64)
param aiFoundryName string = 'ai-${projectName}-${environment}-${uniqueString(resourceGroup().id)}'

@description('Bot Service name (2-64 chars, alphanumeric, hyphens, periods, underscores)')
@minLength(2)
@maxLength(64)
param botServiceName string = 'bot-${projectName}-${environment}-${uniqueString(resourceGroup().id)}'

@description('Container App Environment name (2-32 chars, lowercase letters, numbers, hyphens)')
@minLength(2)
@maxLength(32)
param containerAppEnvironmentName string = 'cae-${projectName}-${environment}-${take(uniqueString(resourceGroup().id), 8)}'

@description('Common tags to apply to all resources')
param tags object = {
  project: 'MyProject'
  environment: environment
  managedBy: 'Bicep'
  deployedFrom: 'GitHub Actions'
}

// Variables for consistent naming
var resourcePrefix = '${projectName}-${environment}'

// Storage Account Module
module storageAccount 'modules/storage-account.bicep' = {
  params: {
    storageAccountName: storageAccountName
    location: location
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    tags: tags
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
}

// Azure AI Search Service Module
module searchService 'modules/search-service.bicep' = {
  params: {
    searchServiceName: searchServiceName
    location: location
    skuName: 'basic'
    replicaCount: 1
    partitionCount: 1
    publicNetworkAccess: 'enabled'
    semanticSearch: 'free'
    disableLocalAuth: false
    tags: tags
  }
}

// AI Foundry Module
module aiFoundry 'modules/ai-foundry.bicep' = {
  params: {
    aiFoundryName: aiFoundryName
    location: location
    skuName: 'S0'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    customSubDomainName: replace(aiFoundryName, '-', '')
    tags: tags
  }
}

// Bot Service Module
module botService 'modules/bot-service.bicep' = {
  params: {
    botServiceName: botServiceName
    botServiceLocation: botServiceLocation
    displayName: '${projectName} Bot ${environment}'
    botDescription: 'Conversational AI bot for ${projectName} project'
    endpoint: 'https://${botServiceName}.azurewebsites.net/api/messages'
    msaAppId: '00000000-0000-0000-0000-000000000000' // This should be replaced with actual App Registration ID
    msaAppType: 'SingleTenant'
    skuName: 'F0'
    kind: 'azurebot'
    disableLocalAuth: false
    isStreamingSupported: true
    publicNetworkAccess: 'Enabled'
    tags: tags
  }
}

// Container App Environment Module
module containerAppEnvironment 'modules/container-app-environment.bicep' = {
  params: {
    containerAppEnvironmentName: containerAppEnvironmentName
    location: location
    zoneRedundant: false
    internal: false
    infrastructureResourceGroup: 'rg-${containerAppEnvironmentName}-infra'
    mtlsEnabled: false
    peerTrafficEncryptionEnabled: false
    tags: tags
  }
}

// Outputs
output resourceGroupName string = resourceGroup().name
output location string = location
output environment string = environment
output resourcePrefix string = resourcePrefix
output storageAccountName string = storageAccount.outputs.storageAccountName
output storageAccountId string = storageAccount.outputs.storageAccountId
output searchServiceName string = searchService.outputs.searchServiceName
output searchServiceId string = searchService.outputs.searchServiceId
output searchServiceUrl string = searchService.outputs.searchServiceUrl
output aiFoundryName string = aiFoundry.outputs.aiFoundryName
output aiFoundryId string = aiFoundry.outputs.aiFoundryId
output aiFoundryEndpoint string = aiFoundry.outputs.aiFoundryEndpoint
output aiFoundryPrincipalId string = aiFoundry.outputs.aiFoundryPrincipalId

// Bot Service Outputs
@description('The name of the Bot Service')
output botServiceName string = botService.outputs.botServiceName

@description('The resource ID of the Bot Service')
output botServiceId string = botService.outputs.botServiceId

@description('The messaging endpoint of the Bot Service')
output botServiceEndpoint string = botService.outputs.botServiceEndpoint

@description('The Microsoft App ID of the Bot Service')
output botServiceMsaAppId string = botService.outputs.botServiceMsaAppId

output containerAppEnvironmentName string = containerAppEnvironment.outputs.containerAppEnvironmentName
output containerAppEnvironmentId string = containerAppEnvironment.outputs.containerAppEnvironmentId
output containerAppEnvironmentDefaultDomain string = containerAppEnvironment.outputs.defaultDomain
output containerAppEnvironmentStaticIp string = containerAppEnvironment.outputs.staticIp
