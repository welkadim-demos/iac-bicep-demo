// Azure Bot Service module
// Creates an Azure Bot Service resource for conversational AI applications

@description('The name of the Bot Service')
param botServiceName string

@description('The location for the Bot Service resource')
@allowed(['global', 'westeurope', 'westus', 'centralindia'])
param botServiceLocation string = 'global'

@description('The display name of the bot')
param displayName string

@description('The description of the bot')
param botDescription string = 'Azure Bot Service created with Bicep'

@description('The bot endpoint URL - typically your web app or function app endpoint')
param endpoint string

@description('Microsoft App ID for the bot (Azure AD Application ID)')
param msaAppId string

@description('Microsoft App Type for the bot')
@allowed(['UserAssignedMSI', 'SingleTenant'])
param msaAppType string = 'SingleTenant'

@description('Microsoft App Tenant Id for the bot')
param msaAppTenantId string = ''

@description('Microsoft App Managed Identity Resource Id for the bot (required if msaAppType is UserAssignedMSI)')
param msaAppMSIResourceId string = ''

@description('The SKU name for the Bot Service')
@allowed(['F0', 'S1'])
param skuName string = 'F0'

@description('The kind of bot resource')
@allowed(['sdk', 'designer', 'bot', 'function', 'azurebot'])
param kind string = 'azurebot'

@description('Whether to disable local authentication')
param disableLocalAuth bool = false

@description('Whether the bot supports streaming')
param isStreamingSupported bool = false

@description('Icon URL for the bot')
param iconUrl string = ''

@description('Application Insights key for bot analytics')
param developerAppInsightKey string = ''

@description('Application Insights App Id')
param developerAppInsightsApplicationId string = ''

@description('Public network access setting')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

@description('Tags to apply to the Bot Service')
param tags object = {}

// Bot Service resource
resource botService 'Microsoft.BotService/botServices@2022-09-15' = {
  name: botServiceName
  location: botServiceLocation  // Bot Service requires 'global' location
  kind: kind
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    displayName: displayName
    description: botDescription
    endpoint: endpoint
    msaAppId: msaAppId
    msaAppType: msaAppType
    msaAppTenantId: !empty(msaAppTenantId) ? msaAppTenantId : null
    msaAppMSIResourceId: !empty(msaAppMSIResourceId) ? msaAppMSIResourceId : null
    disableLocalAuth: disableLocalAuth
    isStreamingSupported: isStreamingSupported
    iconUrl: !empty(iconUrl) ? iconUrl : null
    developerAppInsightKey: !empty(developerAppInsightKey) ? developerAppInsightKey : null
    developerAppInsightsApplicationId: !empty(developerAppInsightsApplicationId) ? developerAppInsightsApplicationId : null
    publicNetworkAccess: publicNetworkAccess
  }
}

// Outputs
@description('The resource ID of the Bot Service')
output botServiceId string = botService.id

@description('The name of the Bot Service')
output botServiceName string = botService.name

@description('The location of the Bot Service')
output botServiceLocation string = botService.location

@description('The endpoint of the Bot Service')
output botServiceEndpoint string = botService.properties.endpoint

@description('The Microsoft App ID of the Bot Service')
output botServiceMsaAppId string = botService.properties.msaAppId

@description('The configured channels for the bot')
output configuredChannels array = botService.properties.configuredChannels

@description('The enabled channels for the bot')
output enabledChannels array = botService.properties.enabledChannels
