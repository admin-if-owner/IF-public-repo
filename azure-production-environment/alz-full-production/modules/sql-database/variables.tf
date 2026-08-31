variable "server_name" {
  description = "Globally unique SQL server name."
  type        = string
}
variable "database_name" {
  type    = string
  default = "appdb"
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "admin_password" {
  description = "SQL admin password. Provide via TF_VAR_ or a non-committed tfvars file."
  type        = string
  sensitive   = true
}
variable "sku_name" {
  description = "Database SKU, e.g. Basic, S0, GP_S_Gen5_2."
  type        = string
  default     = "Basic"
}
variable "max_size_gb" {
  type    = number
  default = 2
}
variable "tags" {
  type    = map(string)
  default = {}
}
