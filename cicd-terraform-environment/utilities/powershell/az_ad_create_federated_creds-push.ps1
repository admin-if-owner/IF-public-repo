$GITHUB_ORG = Read-Host "Enter the Github organization name"
$GITHUB_REPO = Read-Host "Enter the Github repository name"
$GITHUB_ORG_ID = Read-Host "Enter the Github organization ID"
$GITHUB_REPO_ID = Read-Host "Enter the Github repository ID"

# Get the App ID from the first github-actions-terraform app
$APP_ID = az ad app list --display-name "github-actions-terraform" --query "[0].appId" -o tsv 2>$null
if ([string]::IsNullOrEmpty($APP_ID)) {
  Write-Error "Could not find github-actions-terraform app. Please run az_ad_app_registrations.ps1 first."
  exit 1
}

Write-Host "Using App ID: $APP_ID"

$params = @{
    name = "github-actions-main"
    issuer = "https://token.actions.githubusercontent.com"
    subject = "repo:$GITHUB_ORG@$GITHUB_ORG_ID/$GITHUB_REPO@$GITHUB_REPO_ID:ref:refs/heads/main"
    audiences = @("api://AzureADTokenExchange")
    description = "Github Actions - main branch"
} | ConvertTo-Json 

az ad app federated-credential create --id $APP_ID --parameters $params 2>$null
if ($LASTEXITCODE -eq 0) {
  Write-Host "Federated credential created successfully"
} else {
  Write-Error "Failed to create federated credential"
  exit 1
}