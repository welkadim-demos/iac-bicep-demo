# Azure Service Principal Setup Script
# Run this script to create a service principal for GitHub Actions deployment

param(
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory = $false)]
    [string]$ServicePrincipalName = "sp-myproject-github-actions",
    
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName = "rg-myproject"
)

# Login to Azure (if not already logged in)
Write-Host "Checking Azure login status..." -ForegroundColor Yellow
$context = az account show --output json 2>$null | ConvertFrom-Json
if (-not $context) {
    Write-Host "Please login to Azure..." -ForegroundColor Yellow
    az login
}

# Set subscription
Write-Host "Setting subscription: $SubscriptionId" -ForegroundColor Green
az account set --subscription $SubscriptionId

# Create service principal
Write-Host "Creating service principal: $ServicePrincipalName" -ForegroundColor Green
$sp = az ad sp create-for-rbac `
    --name $ServicePrincipalName `
    --role Contributor `
    --scopes "/subscriptions/$SubscriptionId" `
    --output json | ConvertFrom-Json

if ($sp) {
    Write-Host "✓ Service Principal created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "GitHub Repository Secrets Configuration:" -ForegroundColor Cyan
    Write-Host "Add the following secrets to your GitHub repository:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "AZURE_CLIENT_ID: $($sp.appId)" -ForegroundColor White
    Write-Host "AZURE_CLIENT_SECRET: $($sp.password)" -ForegroundColor White
    Write-Host "AZURE_SUBSCRIPTION_ID: $SubscriptionId" -ForegroundColor White
    Write-Host "AZURE_TENANT_ID: $($sp.tenant)" -ForegroundColor White
    Write-Host ""
    Write-Host "Instructions:" -ForegroundColor Cyan
    Write-Host "1. Go to your GitHub repository" -ForegroundColor White
    Write-Host "2. Navigate to Settings > Secrets and variables > Actions" -ForegroundColor White
    Write-Host "3. Add each secret with the values shown above" -ForegroundColor White
    Write-Host "4. Create environments 'development' and 'production' in Settings > Environments" -ForegroundColor White
    Write-Host ""
    Write-Host "Note: Store the AZURE_CLIENT_SECRET securely - it won't be shown again!" -ForegroundColor Red
} else {
    Write-Host "✗ Failed to create service principal" -ForegroundColor Red
}