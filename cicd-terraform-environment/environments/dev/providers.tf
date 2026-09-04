# providers.tf - Provider configuration for Azure Resource Manager
# Uses OpenID Connect (OIDC) for authentication, ideal for GitHub Actions CI/CD

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  # OIDC authentication - no secrets stored in code or pipelines
  # GitHub Actions provides the OIDC token automatically when configured
  use_oidc = true

  # Subscription ID comes from:
  #   Local dev → TF_VAR_subscription_id in .env (loaded by load-env script)
  #   CI/CD     → ARM_SUBSCRIPTION_ID secret in GitHub Actions
  subscription_id = var.subscription_id

  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }

    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}