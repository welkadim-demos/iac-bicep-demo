using '../bicep/main.bicep'

// Development environment parameters
param location = 'westeurope'
param environment = 'dev'
param projectName = 'demorpoject'

// Bot Service location parameter (must use allowed regions)
param botServiceLocation = 'westeurope'

// Custom service names (following Azure naming constraints)
param storageAccountName = 'stdemodev324'  // 10 chars - within 24 char limit
param searchServiceName = 'srch-demo-dev-oct324'
param aiFoundryName = 'ai-demo-dev-oct324'
param botServiceName = 'bot-demo-dev-oct324'
param containerAppEnvironmentName = 'cae-demo-dev-oct324'

// Bot Service Authentication Configuration
// Option 1: SingleTenant with auto App Registration creation
param botAuthType = 'SingleTenant'
param botMsaAppId = '4f8d64e3-04e2-427b-8225-97bab65b5fd6'  // Leave empty for auto-creation
param botTenantId = '2c7a0939-677b-4bd0-8d70-3ab4a6f2a032'  // Leave empty to use deployment tenant automatically
param existingUserManagedIdentityId = ''

// Option 2: UserAssignedMSI with new managed identity creation  
// param botAuthType = 'UserAssignedMSI'
// param botMsaAppId = ''  // Leave empty to create new managed identity
// param existingUserManagedIdentityId = ''

// Option 3: UserAssignedMSI with existing managed identity
// param botAuthType = 'UserAssignedMSI'  
// param botMsaAppId = ''
// param existingUserManagedIdentityId = '/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identity-name}'

param tags = {
  project: 'MyProject'
  environment: 'dev'
  managedBy: 'Bicep'
  deployedFrom: 'GitHub Actions'
  costCenter: 'Development'
}
