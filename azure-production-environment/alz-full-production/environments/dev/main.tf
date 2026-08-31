# ===========================================================================
# Environment composition root. This file wires the reusable modules together
# into one complete landing zone. dev and prod share identical logic; they
# differ only through terraform.tfvars (sizes, counts, SKUs).
# ===========================================================================

locals {
  prefix   = "${var.org}-${var.environment}"
  location = var.location
  tags = {
    environment = var.environment
    owner       = var.owner
    managed_by  = "terraform"
  }
}

# Random suffix keeps globally-unique names (Key Vault, storage, web app, SQL)
# from colliding with other tenants.
resource "random_string" "unique" {
  length  = 5
  upper   = false
  special = false
}

# --------------------------- Resource groups ---------------------------
module "rg_network" {
  source   = "../../modules/resource-group"
  name     = "${local.prefix}-network-rg"
  location = local.location
  tags     = local.tags
}

module "rg_platform" {
  source   = "../../modules/resource-group"
  name     = "${local.prefix}-platform-rg"
  location = local.location
  tags     = local.tags
}

module "rg_workload" {
  source   = "../../modules/resource-group"
  name     = "${local.prefix}-workload-rg"
  location = local.location
  tags     = local.tags
}

# --------------------------- Networking (hub + spoke) ---------------------------
module "hub_network" {
  source              = "../../modules/networking"
  name                = "${local.prefix}-hub-vnet"
  location            = local.location
  resource_group_name = module.rg_network.name
  address_space       = [var.hub_address_space]
  subnets = {
    shared = { address_prefixes = [var.hub_shared_subnet] }
  }
  tags = local.tags
}

module "spoke_network" {
  source              = "../../modules/networking"
  name                = "${local.prefix}-spoke-vnet"
  location            = local.location
  resource_group_name = module.rg_network.name
  address_space       = [var.spoke_address_space]
  subnets = {
    apps = { address_prefixes = [var.spoke_apps_subnet] }
    aks  = { address_prefixes = [var.spoke_aks_subnet] }
    data = { address_prefixes = [var.spoke_data_subnet] }
  }
  tags = local.tags
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = module.rg_network.name
  virtual_network_name      = module.hub_network.vnet_name
  remote_virtual_network_id = module.spoke_network.vnet_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = module.rg_network.name
  virtual_network_name      = module.spoke_network.vnet_name
  remote_virtual_network_id = module.hub_network.vnet_id
  allow_forwarded_traffic   = true
}

# --------------------------- Platform: monitoring + identity + governance ---------------------------
module "monitoring" {
  source              = "../../modules/monitoring"
  name                = "${local.prefix}-law"
  location            = local.location
  resource_group_name = module.rg_platform.name
  tags                = local.tags
}

module "identity" {
  source              = "../../modules/identity"
  prefix              = local.prefix
  key_vault_name      = "${replace(local.prefix, "-", "")}kv${random_string.unique.result}"
  location            = local.location
  resource_group_name = module.rg_platform.name
  tags                = local.tags
}

module "governance" {
  source            = "../../modules/governance"
  resource_group_id = module.rg_workload.id
  allowed_locations = [local.location]
}

# --------------------------- Workloads ---------------------------
module "vm" {
  source              = "../../modules/virtual-machine"
  name                = "${local.prefix}-vm1"
  location            = local.location
  resource_group_name = module.rg_workload.name
  subnet_id           = module.spoke_network.subnet_ids["apps"]
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password
  tags                = local.tags
}

module "aks" {
  source                     = "../../modules/aks"
  name                       = "${local.prefix}-aks"
  location                   = local.location
  resource_group_name        = module.rg_workload.name
  dns_prefix                 = "${local.prefix}-aks"
  subnet_id                  = module.spoke_network.subnet_ids["aks"]
  vm_size                    = var.aks_vm_size
  min_count                  = var.aks_min_count
  max_count                  = var.aks_max_count
  log_analytics_workspace_id = module.monitoring.workspace_id
  tags                       = local.tags
}

module "web_app" {
  source              = "../../modules/web-app"
  name                = "${replace(local.prefix, "-", "")}app${random_string.unique.result}"
  location            = local.location
  resource_group_name = module.rg_workload.name
  sku_name            = var.web_app_sku
  always_on           = var.web_app_always_on
  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = module.monitoring.app_insights_connection_string
  }
  tags = local.tags
}

module "sql" {
  source              = "../../modules/sql-database"
  server_name         = "${replace(local.prefix, "-", "")}sql${random_string.unique.result}"
  database_name       = "appdb"
  location            = local.location
  resource_group_name = module.rg_workload.name
  admin_username      = var.sql_admin_username
  admin_password      = var.sql_admin_password
  sku_name            = var.sql_sku
  max_size_gb         = var.sql_max_size_gb
  tags                = local.tags
}
