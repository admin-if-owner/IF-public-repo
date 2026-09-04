#get your azure subscription id
$SUB_ID = az account show --query id -o tsv

#grant contributer role on the subscription
az role assignment create --assignee $APP_ID --role "Contributor" --scope /subscriptions/$SUB_ID

#if you need to manage role assignments or policies, also add
az role assignment create --assignee $SP_OBJECT_ID --role "User Access Administrator" --scope /subscriptions/$SUB_ID
