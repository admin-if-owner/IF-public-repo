variable "subscription_id" {
  description = "The Azure subscription ID to deploy the state storage into."
  type        = string
}

variable "prefix" {
  description = "Short lowercase org prefix used to name state resources (letters/numbers only)."
  type        = string
  default     = "exco"
}

variable "location" {
  description = "Azure region for the state storage account."
  type        = string
  default     = "eastus"
}
