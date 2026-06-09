@description('Azure Database for PostgreSQL flexible server name')
param postgreSqlServerName string

@description('Location for the PostgreSQL flexible server')
param location string = resourceGroup().location

@description('Administrator login name for the PostgreSQL flexible server')
param administratorLogin string

@description('Administrator login password for the PostgreSQL flexible server')
@secure()
param administratorLoginPassword string

@description('PostgreSQL compute SKU name')
param skuName string = 'Standard_B1ms'

@description('PostgreSQL compute tier')
@allowed(['Burstable', 'GeneralPurpose', 'MemoryOptimized'])
param tier string = 'Burstable'

@description('Availability zone for the PostgreSQL flexible server (-1 disables zonal placement)')
@allowed([-1, 1, 2, 3])
param availabilityZone int = -1

@description('Whether public network access is enabled for the PostgreSQL flexible server')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

@description('High availability mode for the PostgreSQL flexible server')
@allowed(['Disabled', 'SameZone', 'ZoneRedundant'])
param highAvailability string = 'Disabled'

@description('PostgreSQL engine version')
@allowed(['11', '12', '13', '14', '15', '16', '17', '18'])
param version string = '16'

@description('Storage size in GB for the PostgreSQL flexible server')
@minValue(32)
param storageSizeGB int = 32

@description('Backup retention in days for the PostgreSQL flexible server')
@minValue(7)
@maxValue(35)
param backupRetentionDays int = 7

@description('Geo-redundant backup setting for the PostgreSQL flexible server')
@allowed(['Disabled', 'Enabled'])
param geoRedundantBackup string = 'Disabled'

@description('Databases to create on the PostgreSQL flexible server')
param databases array = []

@description('Firewall rules to create on the PostgreSQL flexible server')
param firewallRules array = [
  {
    name: 'AllowAzureServices'
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
]

@description('Tags to apply to the PostgreSQL flexible server')
param tags object = {}

module postgreSql 'br/public:avm/res/db-for-postgre-sql/flexible-server:0.15.0' = {
  name: 'postgresql-${uniqueString(deployment().name, postgreSqlServerName)}'
  params: {
    name: postgreSqlServerName
    location: location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    authConfig: {
      activeDirectoryAuth: 'Disabled'
      passwordAuth: 'Enabled'
    }
    skuName: skuName
    tier: tier
    availabilityZone: availabilityZone
    publicNetworkAccess: publicNetworkAccess
    highAvailability: highAvailability
    backupRetentionDays: backupRetentionDays
    geoRedundantBackup: geoRedundantBackup
    storageSizeGB: storageSizeGB
    version: version
    databases: databases
    firewallRules: firewallRules
    tags: tags
    enableTelemetry: false
  }
}

@description('PostgreSQL flexible server resource ID')
output postgreSqlServerId string = postgreSql.outputs.resourceId

@description('PostgreSQL flexible server name')
output postgreSqlServerName string = postgreSql.outputs.name

@description('PostgreSQL flexible server fully qualified domain name')
output fqdn string = postgreSql.outputs.fqdn ?? ''

@description('Names of the PostgreSQL databases created by this module')
output databaseNames array = [for database in databases: database.name]
