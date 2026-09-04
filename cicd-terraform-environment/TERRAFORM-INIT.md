# Terraform Initialization Guide

## Prerequisites
✅ Azure Storage Account created (stterraformstate83417ead)
✅ Federated credentials created for GitHub Actions
✅ GitHub Secrets configured:
  - `AZURE_CLIENT_ID`
  - `AZURE_SUBSCRIPTION_ID`
  - `AZURE_TENANT_ID`

## Local Development Setup

### 1. Set Environment Variables

```bash
# Copy the example env file
cp .env.example .env

# Edit .env with your actual values
nano .env  # or your editor

# Load the environment variables
source .env
```

### 2. Initialize Terraform (Dev)

```bash
cd environments/dev

# Initialize Terraform with backend
terraform init

# Verify the plan (optional)
terraform plan

# Apply when ready
terraform apply
```

### 3. Initialize Terraform (Prod)

```bash
cd ../prod

# Initialize Terraform with backend
terraform init

# Verify the plan (optional)
terraform plan

# Apply when ready
terraform apply
```

## GitHub Actions CI/CD Setup

When you push to your repository, GitHub Actions will:
1. Use the federated credentials for OIDC authentication
2. Read Azure credentials from GitHub Secrets
3. Automatically initialize Terraform with the backend configuration
4. Deploy to your Azure environment

## Troubleshooting

### Error: "resource_group_name not found"
Make sure you ran `az_initial_storage_setup` script and the storage account exists:
```bash
az storage account show --name stterraformstate83417ead --resource-group stterraformstate83417ead
```

### Error: "invalid subscription_id"
Set the subscription ID before running terraform init:
```bash
export TF_VAR_subscription_id="<your-subscription-id>"
# Get your subscription ID from: az account show --query id -o tsv
```

### Error: "OIDC authentication failed"
Ensure:
1. Federated credentials are created (run `az_ad_create_federated_creds-*.sh`)
2. GitHub Secrets are set correctly
3. You're authenticated with Azure CLI: `az login`

## File Structure

```
cicd-terraform-environment/
├── .env.example                 # Environment variables template
├── environments/
│   ├── dev/
│   │   ├── backend.tf          # ✅ Configured with state storage
│   │   ├── providers.tf        # ✅ OIDC authentication ready
│   │   ├── variables.tf        # ✅ All variables defined
│   │   ├── locals.tf           # ✅ Local values
│   │   ├── main.tf             # Ready for your resources
│   │   ├── outputs.tf          # Ready for your outputs
│   │   └── terraform.tfvars    # ✅ Ready (add subscription_id)
│   └── prod/
│       ├── backend.tf          # ✅ Configured with state storage
│       ├── providers.tf        # ✅ OIDC authentication ready
│       ├── variables.tf        # ✅ All variables defined
│       ├── locals.tf           # ✅ Local values
│       ├── main.tf             # Ready for your resources
│       ├── outputs.tf          # Ready for your outputs
│       └── terraform.tfvars    # ✅ Ready (add subscription_id)
└── utilities/
    ├── bash/
    │   ├── az_ad_app_registration.sh           # ✅ Fixed
    │   ├── az_ad_create_federated_creds-*.sh   # ✅ Fixed
    │   └── ...
    └── powershell/
        ├── az_ad_app_registrations.ps1         # ✅ Fixed
        ├── az_ad_create_federated_creds-*.ps1  # ✅ Fixed
        └── ...
```
