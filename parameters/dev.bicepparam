using '../bicep/main.bicep'

// Development environment parameters
param location = 'East US 2'
param environment = 'dev'
param projectName = 'myproject'

param tags = {
  project: 'MyProject'
  environment: 'dev'
  managedBy: 'Bicep'
  deployedFrom: 'GitHub Actions'
  costCenter: 'Development'
}
