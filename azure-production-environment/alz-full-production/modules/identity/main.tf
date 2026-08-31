# Platform identity building blocks: a Key Vault for secrets and a user-assigned
# managed identity that workloads can use to authenticate without passwords.

data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "this" {
  name                = "${var.prefix}-uami"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_key_vault" "this" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  rbac_authorization_enabled = true
  tags                       = var.tags
}
