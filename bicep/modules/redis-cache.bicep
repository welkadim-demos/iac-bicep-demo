@description('Azure Cache for Redis name')
param redisCacheName string

@description('Location for the Redis cache')
param location string = resourceGroup().location

@description('Redis cache SKU')
@allowed(['Basic', 'Standard', 'Premium'])
param skuName string = 'Standard'

@description('Redis cache capacity')
@allowed([0, 1, 2, 3, 4, 5, 6])
param capacity int = 1

@description('Whether public network access is enabled for the Redis cache')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

@description('Whether the non-SSL Redis port should be enabled')
param enableNonSslPort bool = false

@description('Minimum TLS version required by the Redis cache')
@allowed(['1.0', '1.1', '1.2'])
param minimumTlsVersion string = '1.2'

@description('Redis major version')
@allowed(['4', '6'])
param redisVersion string = '6'

@description('Tags to apply to the Redis cache')
param tags object = {}

module redis 'br/public:avm/res/cache/redis:0.17.0' = {
  name: 'redis-${uniqueString(deployment().name, redisCacheName)}'
  params: {
    name: redisCacheName
    location: location
    skuName: skuName
    capacity: capacity
    publicNetworkAccess: publicNetworkAccess
    enableNonSslPort: enableNonSslPort
    minimumTlsVersion: minimumTlsVersion
    redisVersion: redisVersion
    tags: tags
    enableTelemetry: false
  }
}

@description('Redis cache resource ID')
output redisCacheId string = redis.outputs.resourceId

@description('Redis cache name')
output redisCacheName string = redis.outputs.name

@description('Redis cache hostname')
output hostName string = redis.outputs.hostName

@description('Redis cache SSL port')
output sslPort int = redis.outputs.sslPort
