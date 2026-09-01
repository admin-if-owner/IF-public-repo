# ---- Identity / global ----
variable "org" {
  description = "Short lowercase org code used in names (letters/numbers only)."
  type        = string
  default     = "exco"
}
variable "environment" {
  description = "Environment name, e.g. dev or prod."
  type        = string
}
variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus"
}
variable "owner" {
  description = "Team or person responsible (used as a tag)."
  type        = string
  default     = "platform-team"
}

# ---- Networking ----
variable "hub_address_space" {
  type    = string
  default = "10.0.0.0/16"
}
variable "hub_shared_subnet" {
  type    = string
  default = "10.0.1.0/24"
}
variable "spoke_address_space" {
  type    = string
  default = "10.1.0.0/16"
}
variable "spoke_apps_subnet" {
  type    = string
  default = "10.1.1.0/24"
}
variable "spoke_aks_subnet" {
  type    = string
  default = "10.1.8.0/21"
}
variable "spoke_data_subnet" {
  type    = string
  default = "10.1.16.0/24"
}

# ---- VM ----
variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}
variable "vm_admin_username" {
  type    = string
  default = "azureadmin"
}
variable "vm_admin_password" {
  description = "Set via environment variable TF_VAR_vm_admin_password."
  type        = string
  sensitive   = true
}

# ---- AKS ----
variable "aks_vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}
variable "aks_min_count" {
  type    = number
  default = 1
}
variable "aks_max_count" {
  type    = number
  default = 3
}

# ---- Web App ----
variable "web_app_sku" {
  type    = string
  default = "B1"
}
variable "web_app_always_on" {
  type    = bool
  default = false
}

# ---- SQL ----
variable "sql_admin_username" {
  type    = string
  default = "sqladmin"
}
variable "sql_admin_password" {
  description = "Set via environment variable TF_VAR_sql_admin_password."
  type        = string
  sensitive   = true
}
variable "sql_sku" {
  type    = string
  default = "Basic"
}
variable "sql_max_size_gb" {
  type    = number
  default = 2
}
