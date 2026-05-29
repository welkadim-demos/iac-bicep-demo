@description('The name of the Azure Container Registry')
@minLength(5)
@maxLength(50)
param containerRegistryName string

@description('The location where the Azure Container Registry will be deployed')
param location string = resourceGroup().location

@description('The SKU of the Azure Container Registry')
@allowed(['Basic', 'Standard', 'Premium'])
param skuName string = 'Basic'

@description('Whether admin user is enabled on the registry')
param adminUserEnabled bool = false

@description('Tags to apply to the Azure Container Registry')
param tags object = {}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: containerRegistryName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: 'Enabled'
  }
}

@description('The resource ID of the Azure Container Registry')
output containerRegistryId string = containerRegistry.id

@description('The name of the Azure Container Registry')
output containerRegistryName string = containerRegistry.name

@description('The login server of the Azure Container Registry')
output loginServer string = containerRegistry.properties.loginServer
