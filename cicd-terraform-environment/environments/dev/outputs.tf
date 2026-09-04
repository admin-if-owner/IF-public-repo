# outputs.tf - Displayed after 'terraform apply' and available via remote state

output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = module.hub_network.vnet_id
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault."
  value       = module.identity.key_vault_id
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = local.key_vault_name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace."
  value       = module.log_analytics.workspace_id
}

output "resource_group_names" {
  description = "Map of resource group names created by this configuration."
  value = {
    networking = azurerm_resource_group.networking.name
    security   = azurerm_resource_group.security.name
    monitoring = azurerm_resource_group.monitoring.name
  }
}