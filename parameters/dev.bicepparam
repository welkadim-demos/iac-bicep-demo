using '../bicep/main.bicep'

// Development environment parameters
param location = 'East US 2'
param environment = 'dev'
param projectName = 'diriyah'

param tags = {
  project: 'Diriyah'
  environment: 'dev'
  managedBy: 'Bicep'
  deployedFrom: 'GitHub Actions'
  costCenter: 'Development'
}
