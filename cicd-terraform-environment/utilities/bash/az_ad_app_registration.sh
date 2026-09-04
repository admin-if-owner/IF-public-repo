#create app name

APP_NAME="github-actions-terraform"
APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)
if [ -z "$APP_ID" ]; then
  echo "ERROR: Failed to create app registration" >&2
  exit 1
fi
echo "App (Client) ID: $APP_ID"

#create a service principal for this app
#SP = service principal
SP_OBJECT_ID=$(az ad sp create --id $APP_ID --query id -o tsv 2>/dev/null)
if [ -z "$SP_OBJECT_ID" ]; then
  # Service principal already exists, retrieve it
  SP_OBJECT_ID=$(az ad sp list --filter "appId eq '$APP_ID'" --query "[0].id" -o tsv 2>/dev/null)
  if [ -z "$SP_OBJECT_ID" ]; then
    echo "ERROR: Failed to create or retrieve service principal" >&2
    exit 1
  fi
fi
echo "Service Principal Object ID: $SP_OBJECT_ID"

#get your subscription id from azure
SUB_ID=$(az account show --query id -o tsv)
if [ -z "$SUB_ID" ]; then
  echo "ERROR: Failed to retrieve subscription ID" >&2
  exit 1
fi

#grant yourself contributor role in azure on your subscription
#if you are apart of a team, make sure to correctly apply this to a resource group only, dont want everyone having access to everything
if [ -n "$APP_ID" ]; then
  az role assignment create \
    --assignee $APP_ID \
    --role "Contributor" \
    --scope "/subscriptions/$SUB_ID" 2>/dev/null || echo "WARNING: Failed to grant Contributor role for app registration" >&2
fi

#if you need to manage role assignments for others or create policies, you can also add that here
if [ -n "$SP_OBJECT_ID" ]; then
  az role assignment create \
    --assignee $SP_OBJECT_ID \
    --role "User Access Administrator" \
    --scope "/subscriptions/$SUB_ID" 2>/dev/null || echo "WARNING: Failed to grant User Access Administrator role for service principal" >&2
fi


