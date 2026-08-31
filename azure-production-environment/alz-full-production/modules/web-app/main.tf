# Platform-as-a-Service app hosting: an App Service Plan (the compute) plus a
# Linux Web App (the running site). The plan SKU determines scalability.

resource "azurerm_service_plan" "this" {
  name                = "${var.name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true

  site_config {
    always_on = var.always_on
    application_stack {
      node_version = "20-lts"
    }
  }

  app_settings = var.app_settings

  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}
