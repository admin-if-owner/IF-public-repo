# Fill in your DEV subscription ID. Passwords come from TF_VAR_ env vars, not here.


org         = "test-env"
environment = "dev"
location    = "centralus"
owner       = "platform-team"

# Small + cheap for a development environment
vm_size           = "Standard_D2s_v5"
aks_vm_size       = "Standard_D2s_v5"
aks_min_count     = 1
aks_max_count     = 2
web_app_sku       = "B1"
web_app_always_on = false
sql_sku           = "Basic"
sql_max_size_gb   = 2
