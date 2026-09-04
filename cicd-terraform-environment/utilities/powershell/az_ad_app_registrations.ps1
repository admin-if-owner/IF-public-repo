#create the app registration
$APP_NAME = "github-actions-terraform"
$APP_ID = az ad app create --display-name $APP_NAME --query appId -o tsv 2>$null
if ([string]::IsNullOrEmpty($APP_ID)) {
  Write-Error "Failed to create app registration"
  exit 1
}
Write-Host "App (Client ID): $APP_ID"

#create the service principal
$SP_OBJECT_ID = az ad sp create --id $APP_ID --query id -o tsv 2>$null
if ([string]::IsNullOrEmpty($SP_OBJECT_ID)) {
  # Service principal already exists, retrieve it
  $SP_OBJECT_ID = az ad sp list --filter "appId eq '$APP_ID'" --query "[0].id" -o tsv 2>$null
  if ([string]::IsNullOrEmpty($SP_OBJECT_ID)) {
    Write-Error "Failed to create or retrieve service principal"
    exit 1
  }
}
Write-Host "Service Principal Object ID: $SP_OBJECT_ID"

#get your azure subscription id
$SUB_ID = az account show --query id -o tsv 2>$null
if ([string]::IsNullOrEmpty($SUB_ID)) {
  Write-Error "Failed to retrieve subscription ID"
  exit 1
}

#grant Contributor role on the subscription
if ($APP_ID) {
  az role assignment create --assignee $APP_ID --role "Contributor" --scope /subscriptions/$SUB_ID 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "Failed to grant Contributor role for app registration"
  }
}

#if you need to manage role assignments or policies, also add
if ($SP_OBJECT_ID) {
  az role assignment create --assignee $SP_OBJECT_ID --role "User Access Administrator" --scope /subscriptions/$SUB_ID 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "Failed to grant User Access Administrator role for service principal"
  }
}
