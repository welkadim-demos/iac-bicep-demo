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
