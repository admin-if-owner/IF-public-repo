#create the app registration
$APP_NAME = "github-actions-terraform"
$APP_ID = az ad app create --display-name $APP_NAME --query appId -o tsv
Write-host "App (Client ID): $APP_ID"

#create the service principal
$SP_OBJECT_ID = az ad sp create --id $APP_ID --query objectId -o tsv
Write-host "Service Principal Object ID: $SP_OBJECT_ID"