using '../bicep/main.bicep'

// Production environment parameters
param location = 'East US 2'
param environment = 'prod'
param projectName = 'diriyah'

param tags = {
  project: 'Diriyah'
  environment: 'prod'
  managedBy: 'Bicep'
  deployedFrom: 'GitHub Actions'
  costCenter: 'Production'
}
