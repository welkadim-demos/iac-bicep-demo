@description('The Azure region where resources will be deployed')
param location string = resourceGroup().location

@description('Environment name (dev, staging, prod)')
@allowed(['dev', 'staging', 'prod'])
param environment string = 'dev'

@description('Project name prefix for resource naming')
param projectName string = 'myproject'

@description('Common tags to apply to all resources')
param tags object = {
  project: 'MyProject'
  environment: environment
  managedBy: 'Bicep'
  deployedFrom: 'GitHub Actions'
}

// Variables for consistent naming
var resourcePrefix = '${projectName}-${environment}'
var storageAccountName = 'st${replace(resourcePrefix, '-', '')}${uniqueString(resourceGroup().id)}'
var searchServiceName = 'srch-${resourcePrefix}-${uniqueString(resourceGroup().id)}'
var aiFoundryName = 'ai-${resourcePrefix}-${uniqueString(resourceGroup().id)}'
var botServiceName = 'bot-${resourcePrefix}-${uniqueString(resourceGroup().id)}'
var containerAppEnvironmentName = 'cae-${resourcePrefix}-${uniqueString(resourceGroup().id)}'

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
    location: location
    displayName: '${projectName} Bot ${environment}'
    botDescription: 'Conversational AI bot for ${projectName} project'
    endpoint: 'https://${botServiceName}.azurewebsites.net/api/messages'
    msaAppId: '00000000-0000-0000-0000-000000000000' // This should be replaced with actual App Registration ID
    msaAppType: 'MultiTenant'
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
output botServiceName string = botService.outputs.botServiceName
output botServiceId string = botService.outputs.botServiceId
output botServiceEndpoint string = botService.outputs.botServiceEndpoint
output botServiceMsaAppId string = botService.outputs.botServiceMsaAppId
output containerAppEnvironmentName string = containerAppEnvironment.outputs.containerAppEnvironmentName
output containerAppEnvironmentId string = containerAppEnvironment.outputs.containerAppEnvironmentId
output containerAppEnvironmentDefaultDomain string = containerAppEnvironment.outputs.defaultDomain
output containerAppEnvironmentStaticIp string = containerAppEnvironment.outputs.staticIp
