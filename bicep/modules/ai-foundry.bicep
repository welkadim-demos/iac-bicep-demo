// AI Foundry (Azure Cognitive Services) module
// Creates an Azure AI Services account with kind 'AIServices'

@description('The name of the AI Foundry service')
param aiFoundryName string

@description('The location where the AI Foundry service will be deployed')
param location string = resourceGroup().location

@description('The SKU name for the AI Foundry service')
@allowed(['F0', 'S0', 'S1', 'S2', 'S3', 'S4'])
param skuName string = 'S0'

@description('The public network access setting')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

@description('Whether to disable local authentication')
param disableLocalAuth bool = false

@description('Custom subdomain name for token-based authentication')
param customSubDomainName string = ''

@description('Tags to apply to the AI Foundry service')
param tags object = {}

// AI Foundry service (Cognitive Services account with AIServices kind)
resource aiFoundry 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: aiFoundryName
  location: location
  kind: 'AIServices'
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: skuName
  }
  properties: {
    publicNetworkAccess: publicNetworkAccess
    disableLocalAuth: disableLocalAuth
    customSubDomainName: !empty(customSubDomainName) ? customSubDomainName : null
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

// Outputs
@description('The resource ID of the AI Foundry service')
output aiFoundryId string = aiFoundry.id

@description('The name of the AI Foundry service')
output aiFoundryName string = aiFoundry.name

@description('The endpoint URL of the AI Foundry service')
output aiFoundryEndpoint string = aiFoundry.properties.endpoint

@description('The location of the AI Foundry service')
output aiFoundryLocation string = aiFoundry.location

@description('The principal ID of the system-assigned managed identity')
output aiFoundryPrincipalId string = aiFoundry.identity.principalId

@description('The custom subdomain name if configured')
output customSubDomainName string = aiFoundry.properties.customSubDomainName ?? ''
