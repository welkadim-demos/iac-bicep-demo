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

// Example resource group output (if deploying to subscription scope)
output resourceGroupName string = resourceGroup().name
output location string = location
output environment string = environment
output resourcePrefix string = resourcePrefix

// Add your Azure resources here
// Example: Storage Account, App Service, Key Vault, etc.
