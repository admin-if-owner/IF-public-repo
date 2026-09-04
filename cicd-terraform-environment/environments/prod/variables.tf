# variables.tf - Root module input variables

# --- REQUIRED ---

variable "subscription_id" {
  description = "The Azure subscription ID where resources will be deployed."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.subscription_id))
    error_message = "The subscription_id must be a valid UUID."
  }
}

# --- OPTIONAL (sensible defaults) ---

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "eastus2"

  validation {
    condition     = contains(["eastus", "eastus2", "westus2", "westus3", "centralus", "northeurope", "westeurope", "uksouth", "ukwest"], var.location)
    error_message = "The location must be a supported Azure region."
  }
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "A short name for the project, used in resource naming conventions."
  type        = string
  default     = "starter"

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{2,11}$", var.project_name))
    error_message = "The project_name must be 3-12 lowercase alphanumeric characters, starting with a letter."
  }
}

# --- NETWORKING ---

variable "hub_vnet_address_space" {
  description = "Address space for the hub virtual network in CIDR notation."
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke_prod_address_space" {
  description = "Address space for the production spoke virtual network in CIDR notation."
  type        = string
  default     = "10.1.0.0/16"
}

# --- MONITORING ---

variable "log_retention_days" {
  description = "Number of days to retain logs in Log Analytics."
  type        = number
  default     = 90

  validation {
    condition     = var.log_retention_days >= 30 && var.log_retention_days <= 730
    error_message = "Log retention must be between 30 and 730 days."
  }
}

# --- TAGS ---

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}