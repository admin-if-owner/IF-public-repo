# Fill in your DEV subscription ID. Passwords come from TF_VAR_ env vars, not here.
subscription_id = "00000000-0000-0000-0000-000000000000"

org         = "exco"
environment = "dev"
location    = "eastus"
owner       = "platform-team"

# Small + cheap for a development environment
vm_size           = "Standard_B2s"
aks_vm_size       = "Standard_B2s"
aks_min_count     = 1
aks_max_count     = 2
web_app_sku       = "B1"
web_app_always_on = false
sql_sku           = "Basic"
sql_max_size_gb   = 2
