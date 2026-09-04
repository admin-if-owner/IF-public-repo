terraform {
  backend "azurerm" {
    resource_group_name  = "stterraformstate83417ead"
    storage_account_name = "stterraformstate83417ead"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
    use_oidc             = true
    # subscription_id, client_id, and tenant_id will come from:
    #   Local dev: environment variables (ARM_SUBSCRIPTION_ID, ARM_CLIENT_ID, ARM_TENANT_ID)
    #   CI/CD: GitHub Actions secrets (ARM_SUBSCRIPTION_ID, ARM_CLIENT_ID, ARM_TENANT_ID)
  }
}
