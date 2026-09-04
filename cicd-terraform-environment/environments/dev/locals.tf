# locals.tf - Local values used across the configuration

locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Repository  = "IF-public-repo"
    },
    var.tags
  )

  # Naming convention: {project}-{environment}
  name_prefix    = "${var.project_name}-${var.environment}"
  key_vault_name = "${replace(local.name_prefix, "-", "")}kv"
}
