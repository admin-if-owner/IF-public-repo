variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "size" {
  description = "VM size, e.g. Standard_B2s."
  type        = string
  default     = "Standard_B2s"
}
variable "admin_username" {
  type = string
}
variable "admin_password" {
  description = "Admin password. Provide via TF_VAR_ or a non-committed tfvars file."
  type        = string
  sensitive   = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
