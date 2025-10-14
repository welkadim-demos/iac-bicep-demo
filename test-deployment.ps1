# Simple deployment test script
param(
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory = $false)]
    [string]$Location = "East US 2",
    
    [Parameter(Mandatory = $false)]
    [string]$Environment = "dev"
)

# Set subscription
az account set --subscription $SubscriptionId

# Create resource group
az group create --name $ResourceGroupName --location $Location --tags project=MyProject environment=$Environment managedBy=Bicep

# Validate template
az deployment group validate --resource-group $ResourceGroupName --template-file "bicep/main.bicep" --parameters "parameters/${Environment}.bicepparam"

# Preview deployment
az deployment group what-if --resource-group $ResourceGroupName --template-file "bicep/main.bicep" --parameters "parameters/${Environment}.bicepparam"

# Deploy template
$deploymentName = "storage-account-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
az deployment group create --resource-group $ResourceGroupName --template-file "bicep/main.bicep" --parameters "parameters/${Environment}.bicepparam" --name $deploymentName

# Show outputs
az deployment group show --resource-group $ResourceGroupName --name $deploymentName --query properties.outputs --output table