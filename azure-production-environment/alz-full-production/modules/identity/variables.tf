variable "prefix" {
  description = "Naming prefix, e.g. exco-dev."
  type        = string
}
variable "key_vault_name" {
  description = "Globally unique Key Vault name (3-24 chars, letters/numbers)."
  type        = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
