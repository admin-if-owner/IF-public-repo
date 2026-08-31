output "resource_group_name" {
  description = "Copy this into your backend config (resource_group_name)."
  value       = azurerm_resource_group.state.name
}

output "storage_account_name" {
  description = "Copy this into your backend config (storage_account_name)."
  value       = azurerm_storage_account.state.name
}

output "container_name" {
  description = "Copy this into your backend config (container_name)."
  value       = azurerm_storage_container.state.name
}
