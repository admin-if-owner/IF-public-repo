#get your subscription id from azure
SUB_ID=$(az account show --query id -o tsv)

#grant yourself contributer role in azure on your subscription
#if you are apart of a team, make sure to correctly apply this to a resource group only, dont want everyone having access to everything
az role assignment create \
  --assignees $SP_OBJECT_ID \
  --role "Contributer" \
  --scope "/subscriptions/$SUB_ID"

#if you need to manage role assignemnts for others or create policies, you can also add that here
az role assignment create \
  --assignee $SP_OBJECT_ID \
  --role "User Access Administrator" \
  --scope "/subscriptions/$SUB_ID"
