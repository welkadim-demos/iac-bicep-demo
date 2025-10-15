using '../bicep/main.bicep'

// Development environment parameters
param location = 'westeurope'
param environment = 'dev'
param projectName = 'myproject'

// Bot Service location parameter (must use allowed regions)
param botServiceLocation = 'westeurope'

// Custom service names (following Azure naming constraints)
param storageAccountName = 'stdemodev24'  // 10 chars - within 24 char limit
param searchServiceName = 'srch-demo-dev-oct24'
param aiFoundryName = 'ai-demo-dev-oct24'
param botServiceName = 'bot-demo-dev-oct24'
param containerAppEnvironmentName = 'cae-demo-dev-oct24'

param tags = {
  project: 'MyProject'
  environment: 'dev'
  managedBy: 'Bicep'
  deployedFrom: 'GitHub Actions'
  costCenter: 'Development'
}
