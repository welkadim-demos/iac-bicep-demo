@description('The name of the Container App')
@minLength(2)
@maxLength(32)
param containerAppName string

@description('The location where the Container App will be deployed')
param location string = resourceGroup().location

@description('The resource ID of the Container App Environment')
param managedEnvironmentId string

@description('The container image to deploy')
param image string

@description('The port exposed by the container')
param targetPort int = 3000

@description('The number of minimum replicas')
param minReplicas int = 1

@description('The number of maximum replicas')
param maxReplicas int = 2

@description('Whether ingress is exposed publicly')
param ingressExternal bool = true

@description('CPU cores assigned to the container')
param cpu string = '0.25'

@description('Memory assigned to the container (Gi)')
param memory string = '0.5Gi'

@description('Container registry server used for image pulls')
param registryServer string

@description('Tags to apply to the Container App')
param tags object = {}

resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: containerAppName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: managedEnvironmentId
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
        external: ingressExternal
        targetPort: targetPort
        transport: 'auto'
        allowInsecure: false
      }
      registries: [
        {
          server: registryServer
          identity: 'system'
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'node-app'
          image: image
          resources: {
            cpu: json(cpu)
            memory: memory
          }
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}

@description('The resource ID of the Container App')
output containerAppId string = containerApp.id

@description('The name of the Container App')
output containerAppName string = containerApp.name

@description('The principal ID of the system-assigned managed identity')
output containerAppPrincipalId string = containerApp.identity.principalId

@description('The URL of the Container App')
output containerAppUrl string = 'https://${containerApp.properties.configuration.ingress.fqdn}'
