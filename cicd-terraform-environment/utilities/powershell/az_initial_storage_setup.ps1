# variables you can customize to your liking, think about your naming convention that makes sense to you
RESOURCE_GROUP_NAME = "rg-terraform-state"
$RANDOM_HEX = -join ((48..57) + (97..102) | Get-Random -Count 8 | ForEach-Object {[char]$_})
STORAGE_ACCOUNT_NAME = "stterraformstate$RANDOM_HEX" #this value must be globally unique so we use a random generator to add some numbers at the end
CONTAINER_NAME = "tfstate"
LOCATION = "centralus" #pick a location close to you, pricing does vary though, keep it in mind

#create a resource group
az group create `
  --name $RESOURCE_GROUP_NAME `
  --location $LOCATION

#create storage account
az storage account create `
  --name $STORAGE_ACCOUNT_NAME `
  --resource-group $RESOURCE_GROUP_NAME `
  --location $LOCATION `
  --sku Standard_LRS `
  --encryption-services blob `
  --min-tls-version TLS1_2 `
  --allow-blob-public-access false

#create blob container
az storage container create `
 --name $CONTAINER_NAME `
 --account-name $STORAGE_ACCOUNT_NAME

#enable versioning for state file recovery
az storage account blob-service-properties update `
  --account-name $STORAGE_ACCOUNT_NAME `
  --resource-group $RESOURCE_GROUP_NAME `
  --enable-versioning true

Write-host "Storage Account Name: $STORAGE_ACCOUNT_NAME"
Write-host "Save this name - you will need it for your .env file"
