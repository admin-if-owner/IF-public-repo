variable "name" {
  description = "Globally unique web app name."
  type        = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "sku_name" {
  description = "App Service Plan SKU, e.g. B1 (dev) or P1v3 (prod, autoscale-capable)."
  type        = string
  default     = "B1"
}
variable "always_on" {
  type    = bool
  default = false
}
variable "app_settings" {
  type    = map(string)
  default = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
