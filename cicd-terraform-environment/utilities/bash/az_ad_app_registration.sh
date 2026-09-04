#create app name

APP_NAME="github-actions-terraform"
APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)
echo "App (Client) ID: "$APP_ID"

#create a service principal for this app
#SP = service principal
SP_OBJECT_ID=$(az ad sp create --id $APP_ID --query id -o tsv)
echo "Service Principal Object ID: $SP_OBJECT_ID"

