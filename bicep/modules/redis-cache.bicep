// Azure Managed Redis Cache Bicep Module
// This module creates an Azure Managed Redis (Redis Enterprise) cluster with a default database

@description('Name of the Azure Managed Redis cluster')
@minLength(1)
@maxLength(60)
param redisCacheName string

@description('Location for the Redis cluster')
param location string = resourceGroup().location

@description('SKU for the Azure Managed Redis cluster')
@allowed(['Balanced_B0', 'Balanced_B1', 'Balanced_B3', 'Balanced_B5', 'MemoryOptimized_M10', 'ComputeOptimized_X3', 'ComputeOptimized_X5'])
param skuName string = 'Balanced_B0'

@description('Clustering policy for the Redis database')
@allowed(['EnterpriseCluster', 'OSSCluster'])
param clusteringPolicy string = 'OSSCluster'

@description('Eviction policy for the Redis database')
@allowed(['AllKeysLFU', 'AllKeysLRU', 'AllKeysRandom', 'VolatileLFU', 'VolatileLRU', 'VolatileRandom', 'VolatileTTL', 'NoEviction'])
param evictionPolicy string = 'NoEviction'

@description('Client protocol used to communicate with the Redis database')
@allowed(['Encrypted', 'Plaintext'])
param clientProtocol string = 'Encrypted'

@description('Minimum TLS version accepted by the Redis cluster')
@allowed(['1.0', '1.1', '1.2'])
param minimumTlsVersion string = '1.2'

@description('Whether zone redundancy / high availability is enabled for the Redis cluster')
@allowed(['Enabled', 'Disabled'])
param highAvailability string = 'Enabled'

@description('Tags to apply to the Redis cache resources')
param tags object = {}

// Create Azure Managed Redis Cluster
resource redisCluster 'Microsoft.Cache/redisEnterprise@2024-09-01-preview' = {
  name: redisCacheName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    minimumTlsVersion: minimumTlsVersion
    highAvailability: highAvailability
  }
}

// Default database for the Redis cluster
resource redisDatabase 'Microsoft.Cache/redisEnterprise/databases@2024-09-01-preview' = {
  name: 'default'
  parent: redisCluster
  properties: {
    clientProtocol: clientProtocol
    clusteringPolicy: clusteringPolicy
    evictionPolicy: evictionPolicy
    port: 10000
  }
}

// Outputs
@description('The resource ID of the Redis cluster')
output redisCacheId string = redisCluster.id

@description('The name of the Redis cluster')
output redisCacheName string = redisCluster.name

@description('The host name of the Redis cluster')
output redisCacheHostName string = redisCluster.properties.hostName

@description('The port used to connect to the Redis database')
output redisCachePort int = redisDatabase.properties.port

@description('The resource ID of the default Redis database')
output redisDatabaseId string = redisDatabase.id
