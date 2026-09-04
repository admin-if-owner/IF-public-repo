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
  source = "../../../azure-production-environment/alz-full-production/modules/monitoring"

  resource_group_name = azurerm_resource_group.monitoring.name
  location            = var.location
  name                = "${local.name_prefix}-law"
  retention_in_days   = var.log_retention_days
  tags                = local.common_tags
}

# --- Networking (hub-and-spoke topology) ---

module "hub_network" {
  source = "../../../azure-production-environment/alz-full-production/modules/networking"

  resource_group_name = azurerm_resource_group.networking.name
  location            = var.location
  name                = "${local.name_prefix}-hub"
  address_space       = var.hub_vnet_address_space
  subnets = {
    apps = {
      address_prefixes = ["10.0.1.0/24"]
    }
    management = {
      address_prefixes = ["10.0.2.0/24"]
    }
  }
  tags = local.common_tags
}

# --- Security (Key Vault) ---

module "identity" {
  source = "../../../azure-production-environment/alz-full-production/modules/identity"

  prefix              = local.name_prefix
  key_vault_name      = local.key_vault_name
  resource_group_name = azurerm_resource_group.security.name
  location            = var.location
  tags                = local.common_tags
}