// Azure AI Search Service Bicep Module
// This module creates an Azure AI Search service with secure defaults

@description('Name of the Azure Search service')
param searchServiceName string

@description('Location for the search service')
param location string = resourceGroup().location

@description('SKU tier for the search service')
@allowed(['free', 'basic', 'standard', 'standard2', 'standard3', 'storage_optimized_l1', 'storage_optimized_l2'])
param skuName string = 'basic'

@description('Number of replicas for the search service')
@minValue(1)
@maxValue(12)
param replicaCount int = 1

@description('Number of partitions for the search service')
@minValue(1)
@maxValue(12)
param partitionCount int = 1

@description('Public network access setting')
@allowed(['enabled', 'disabled'])
param publicNetworkAccess string = 'enabled'

@description('Semantic search configuration')
@allowed(['disabled', 'free', 'standard'])
param semanticSearch string = 'free'

@description('Hosting mode for standard3 SKU')
@allowed(['default', 'highDensity'])
param hostingMode string = 'default'

@description('Whether to disable local authentication')
param disableLocalAuth bool = false

@description('Tags to apply to the search service')
param tags object = {}

@description('IP firewall rules for the search service')
param ipRules array = []

// Create Azure AI Search Service
resource searchService 'Microsoft.Search/searchServices@2023-11-01' = {
  name: searchServiceName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    replicaCount: replicaCount
    partitionCount: partitionCount
    hostingMode: hostingMode
    publicNetworkAccess: publicNetworkAccess
    semanticSearch: semanticSearch
    disableLocalAuth: disableLocalAuth
    networkRuleSet: !empty(ipRules) ? {
      ipRules: ipRules
    } : null
    authOptions: !disableLocalAuth ? {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    } : null
    encryptionWithCmk: {
      enforcement: 'Unspecified'
    }
  }
}

// Outputs
@description('The resource ID of the search service')
output searchServiceId string = searchService.id

@description('The name of the search service')
output searchServiceName string = searchService.name

@description('The URL endpoint of the search service')
output searchServiceUrl string = 'https://${searchService.name}.search.windows.net'

@description('The provisioning state of the search service')
output provisioningState string = searchService.properties.provisioningState

@description('The status of the search service')
output status string = searchService.properties.status

@description('The principal ID of the system-assigned managed identity')
output principalId string = searchService.identity.principalId

@description('The tenant ID of the system-assigned managed identity')
output tenantId string = searchService.identity.tenantId
