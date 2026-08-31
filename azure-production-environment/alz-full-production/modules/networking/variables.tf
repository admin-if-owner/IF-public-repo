variable "name" {
  description = "Virtual network name."
  type        = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "address_space" {
  description = "List of CIDR blocks for the VNet, e.g. [\"10.1.0.0/16\"]."
  type        = list(string)
}
variable "subnets" {
  description = "Map of subnet name => { address_prefixes = [...] }."
  type = map(object({
    address_prefixes = list(string)
  }))
}
variable "tags" {
  type    = map(string)
  default = {}
}
