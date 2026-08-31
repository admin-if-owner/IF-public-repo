# Fill in your PROD subscription ID. Passwords come from TF_VAR_ env vars, not here.
subscription_id = "00000000-0000-0000-0000-000000000000"

org         = "exco"
environment = "prod"
location    = "eastus"
owner       = "platform-team"

# Larger + resilient for production, with room to scale out
vm_size           = "Standard_D2s_v5"
aks_vm_size       = "Standard_D4s_v5"
aks_min_count     = 3
aks_max_count     = 10
web_app_sku       = "P1v3"
web_app_always_on = true
sql_sku           = "S1"
sql_max_size_gb   = 50
