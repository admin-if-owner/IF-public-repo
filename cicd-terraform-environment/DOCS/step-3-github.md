we are now setting up federated authentication with azure from github for pushes/pulls/productioin environment

this is a one time setup, from the untilities folder run the az_ad_create_federated_creds push/pull/prod scripts

they will ask you 2 questions at the top of each script, your org and your repo name

once completed, you will log back into your github and set up some secerts, 
    open your repo 
    click settings
    click on secrets and vairables
    under repository secrets add
        AZURE_CLIENT_ID
            to get the value run the bash/powershell command
                APP_NAME="github-actions-terraform"
                APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)
                if [ -z "$APP_ID" ]; then
                  echo "ERROR: Failed to create app registration" >&2
                  exit 1
                fi
                echo "App (Client) ID: $APP_ID"
        AZURE_SUBSCRIPTION_ID
            az account show --query id -o tsv
        AZURE_TENANT_ID
            az account show --query tenantId -o tsv

once you have pasted the Key's and Values into secrets, go back to the left hand column and click on environments 
name it production and set any additonal rules to it that you want
save the changes and then we turn to create terraform files