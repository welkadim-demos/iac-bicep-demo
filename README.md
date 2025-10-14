# Diriyah IaC PoC

This repository contains Infrastructure as Code (IaC) templates using Azure Bicep for the Diriyah project.

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

### GitHub Actions Deployment

Push changes to trigger automated deployment through GitHub Actions workflows.

## Configuration

Configure the following GitHub repository secrets:
- `AZURE_CLIENT_ID`: Service Principal Client ID
- `AZURE_CLIENT_SECRET`: Service Principal Secret
- `AZURE_SUBSCRIPTION_ID`: Azure Subscription ID
- `AZURE_TENANT_ID`: Azure Tenant ID

## Environments

- **Development**: Deployed from `dev` branch
- **Production**: Deployed from `main` branch