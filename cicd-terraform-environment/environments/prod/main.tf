# main.tf - Root module orchestration
# Wires together all child modules to create the core infrastructure:
#   - Hub-and-spoke network topology
#   - Centralized Key Vault for secrets management
#   - Log Analytics workspace for monitoring

# --- Resource Groups ---

resource "azurerm_resource_group" "networking" {
  name     = "rg-${local.name_prefix}-networking"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "security" {
  name     = "rg-${local.name_prefix}-security"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "monitoring" {
  name     = "rg-${local.name_prefix}-monitoring"
  location = var.location
  tags     = local.common_tags
}

# --- Monitoring (deployed first so other modules can send diagnostics here) ---

module "log_analytics" {
  source = "../../azure-production-environment/alz-full-production/modules/monitoring"

  resource_group_name = azurerm_resource_group.monitoring.name
  location            = var.location
  name_prefix         = local.name_prefix
  retention_days      = var.log_retention_days
  tags                = local.common_tags
}

# --- Networking (hub-and-spoke topology) ---

module "hub_network" {
  source = "../../azure-production-environment/alz-full-production/modules/networking"

  resource_group_name = azurerm_resource_group.networking.name
  location            = var.location
  name_prefix         = local.name_prefix
  address_space       = var.hub_vnet_address_space
  tags                = local.common_tags

  log_analytics_workspace_id = module.log_analytics.workspace_id
}

# --- Security (Key Vault) ---

module "key_vault" {
  source = "../../azure-production-environment/alz-full-production/modules/security/key-vault"

  resource_group_name = azurerm_resource_group.security.name
  location            = var.location
  name_prefix         = local.name_prefix
  tags                = local.common_tags

  log_analytics_workspace_id = module.log_analytics.workspace_id
}