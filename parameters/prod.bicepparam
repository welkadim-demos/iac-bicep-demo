using '../bicep/main.bicep'

// Production environment parameters
param location = 'East US 2'
param environment = 'prod'
param projectName = 'myproject'

param tags = {
  project: 'MyProject'
  environment: 'prod'
  managedBy: 'Bicep'
  deployedFrom: 'GitHub Actions'
  costCenter: 'Production'
}
