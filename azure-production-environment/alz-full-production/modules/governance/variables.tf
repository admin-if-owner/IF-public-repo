variable "resource_group_id" {
  description = "Resource group ID to scope the policy to."
  type        = string
}
variable "allowed_locations" {
  description = "List of allowed Azure regions."
  type        = list(string)
}
