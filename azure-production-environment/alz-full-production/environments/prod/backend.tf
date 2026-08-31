# The actual values (resource group, storage account, container, key) are passed
# at init time with -backend-config so the same code works for every environment.
# See GETTING-STARTED.md, step 5.
terraform {
  backend "azurerm" {}
}
