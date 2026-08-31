output "resource_groups" {
  value = {
    network  = module.rg_network.name
    platform = module.rg_platform.name
    workload = module.rg_workload.name
  }
}
output "aks_cluster_name" {
  value = module.aks.cluster_name
}
output "web_app_hostname" {
  value = module.web_app.default_hostname
}
output "sql_server_fqdn" {
  value = module.sql.server_fqdn
}
output "key_vault_id" {
  value = module.identity.key_vault_id
}
