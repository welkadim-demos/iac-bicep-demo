# Azure IaC Project

This repository contains Infrastructure as Code (IaC) templates using Azure Bicep for your cloud infrastructure deployment.

## Structure

```
├── .github/
│   └── workflows/          # GitHub Actions workflows
├── bicep/
│   ├── modules/           # Reusable Bicep modules
│   └── main.bicep         # Main deployment template
├── parameters/            # Parameter files for different environments
└── README.md
```

## Prerequisites

- Azure CLI installed
- Azure subscription with appropriate permissions
- GitHub repository with secrets configured

## Usage

### Local Deployment

```bash
# Login to Azure
az login

# Deploy to a resource group
az deployment group create \
  --resource-group <resource-group-name> \
  --template-file bicep/main.bicep \
  --parameters @parameters/dev.bicepparam
```

To include the new Redis Cache and PostgreSQL modules in a deployment, enable them and pass the PostgreSQL administrator password at deploy time:

```bash
az deployment group create \
  --resource-group <resource-group-name> \
  --template-file bicep/main.bicep \
  --parameters @parameters/dev.bicepparam \
  --parameters deployRedisCache=true \
               deployPostgreSql=true \
               postgreSqlAdministratorLoginPassword='<secure-password>'
```

### GitHub Actions Deployment

Push changes to trigger automated deployment through GitHub Actions workflows.

## Configuration

Configure the following GitHub repository secrets:
- `AZURE_CLIENT_ID`: Service Principal Client ID
- `AZURE_CLIENT_SECRET`: Service Principal Secret
- `AZURE_SUBSCRIPTION_ID`: Azure Subscription ID
- `AZURE_TENANT_ID`: Azure Tenant ID

### Redis Cache parameters

- `deployRedisCache`: Enables the Azure Verified Module-backed Redis deployment
- `redisCacheName`: Redis cache resource name
- `redisCacheSkuName`: Redis SKU (`Basic`, `Standard`, or `Premium`)
- `redisCacheCapacity`: Redis cache size/capacity

### PostgreSQL parameters

- `deployPostgreSql`: Enables the Azure Verified Module-backed PostgreSQL deployment
- `postgreSqlServerName`: PostgreSQL flexible server resource name
- `postgreSqlAdministratorLogin`: PostgreSQL administrator username
- `postgreSqlAdministratorLoginPassword`: Secure PostgreSQL administrator password
- `postgreSqlSkuName`: PostgreSQL compute SKU name
- `postgreSqlTier`: PostgreSQL compute tier
- `postgreSqlAvailabilityZone`: Availability zone selection (`-1` disables zonal placement)
- `postgreSqlVersion`: PostgreSQL engine version
- `postgreSqlStorageSizeGB`: Allocated storage size
- `postgreSqlBackupRetentionDays`: Backup retention period
- `postgreSqlDatabases`: Array of databases to create
- `postgreSqlFirewallRules`: Array of public firewall rules to create

### Outputs

- `redisCacheName`, `redisCacheId`, `redisCacheHostName`, `redisCacheSslPort`
- `postgreSqlServerName`, `postgreSqlServerId`, `postgreSqlServerFqdn`, `postgreSqlDatabaseNames`

## Environments

- **Development**: Deployed from `dev` branch
- **Production**: Deployed from `main` branch