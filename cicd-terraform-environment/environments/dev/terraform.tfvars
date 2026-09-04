# Dev Environment Variables
# For GitHub Actions CI/CD: Use environment variables instead
#   - ARM_SUBSCRIPTION_ID (from GitHub secrets)
#   - ARM_CLIENT_ID (from GitHub secrets)
#   - ARM_TENANT_ID (from GitHub secrets)
# For local development: Export these as environment variables or use -var flags

# REQUIRED: Azure subscription ID
# You can pass this via: -var="subscription_id=<your-id>" during terraform init/apply
# Or set it via: export TF_VAR_subscription_id="<your-id>"
# GitHub Actions will use ARM_SUBSCRIPTION_ID from secrets
# Set TF_VAR_subscription_id in the local environment instead.

# OPTIONAL: Override defaults if needed
# location         = "eastus2"
environment = "dev"
# project_name     = "starter"
# log_retention_days = 90

# Example tags to apply to all resources:
# tags = {
#   CostCenter = "Engineering"
#   Owner      = "TeamName"
#   CreatedBy  = "Terraform"
# }
