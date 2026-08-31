# Getting Started: from an empty laptop to a deployed environment

This is a copy-paste walkthrough. Read `ARCHITECTURE.md` first for the concepts; this file is the hands-on part. Commands are shown for **Windows PowerShell** (with macOS/Linux notes where they differ). Do the whole thing on `dev` first — never learn on production.

Estimated time the first time through: about an hour, most of it waiting on Azure.

---

## Step 0 — Make an Azure account

1. Go to <https://azure.microsoft.com/free> and sign up. New accounts get free credit.
2. Signing up creates a **subscription** (the billing + isolation boundary all your resources live in). You will need its ID shortly.

> Cost warning: this project creates real, billable resources (a Kubernetes cluster, a VM, a database). Free credit covers experimentation, but always run `terraform destroy` (Step 8) when you stop for the day.

---

## Step 1 — Install the two tools

You need **Terraform** and the **Azure CLI**.

**Windows** (run PowerShell as Administrator; uses the built-in `winget`):

```powershell
winget install --id HashiCorp.Terraform -e
winget install --id Microsoft.AzureCLI -e
```

**macOS** (uses Homebrew):

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew install azure-cli
```

Close and reopen your terminal, then confirm both installed:

```powershell
terraform version
az version
```

You want Terraform 1.6 or newer.

---

## Step 2 — Log in and pick your subscription

```powershell
az login
```

A browser window opens; sign in. Then list your subscriptions and note the `id` you want to use:

```powershell
az account list --output table
az account set --subscription "<YOUR-SUBSCRIPTION-ID>"
```

Terraform will automatically reuse this `az login` session, so you do not need to store any credentials in files.

---

## Step 3 — Get the code

Put this `azure-landing-zone` folder wherever you keep projects, and open a terminal inside it. Everything below assumes you are in the `azure-landing-zone` directory.

If you use Git (recommended), initialize a repo now so your history is tracked. The included `.gitignore` already blocks state files and secrets:

```powershell
git init
git add .
git commit -m "Initial landing zone"
```

---

## Step 4 — Bootstrap the remote state storage (run once, ever)

This creates the Azure Storage account that will hold Terraform's state for every environment. See `ARCHITECTURE.md` section 8 for why this exists.

```powershell
cd bootstrap
terraform init
terraform apply -var="subscription_id=<YOUR-SUBSCRIPTION-ID>"
```

Terraform prints a plan and asks you to type `yes`. After it finishes, it prints three outputs — **write these down**, you need them in the next step:

```
resource_group_name  = "exco-tfstate-rg"
storage_account_name = "excotfstateabc123"
container_name       = "tfstate"
```

Then go back up:

```powershell
cd ..
```

---

## Step 5 — Point the dev environment at that state and initialize

Move into the dev environment and open `terraform.tfvars`. Set `subscription_id` to your subscription (and adjust `location` if you do not want `eastus`). Save it.

Now initialize, passing the three bootstrap values as **backend config**. This is how the same code targets different state per environment. Replace the three values with what Step 4 printed:

```powershell
cd environments/dev

terraform init `
  -backend-config="resource_group_name=exco-tfstate-rg" `
  -backend-config="storage_account_name=excotfstateabc123" `
  -backend-config="container_name=tfstate" `
  -backend-config="key=dev.terraform.tfstate"
```

(On macOS/Linux, replace the backtick line-continuations with `\`.)

The `key` is the filename this environment's state gets inside the container — `dev.terraform.tfstate` here, `prod.terraform.tfstate` later. Different keys keep the environments' state completely separate.

---

## Step 6 — Provide the secret passwords (never put these in files)

The VM and SQL database need admin passwords. Pass them as environment variables so they never touch disk. Choose strong values (SQL requires upper, lower, number, and symbol):

**Windows PowerShell:**

```powershell
$env:TF_VAR_vm_admin_password  = "ChangeMe-Str0ng!Pass"
$env:TF_VAR_sql_admin_password = "ChangeMe-Str0ng!Pass2"
```

**macOS/Linux:**

```bash
export TF_VAR_vm_admin_password="ChangeMe-Str0ng!Pass"
export TF_VAR_sql_admin_password="ChangeMe-Str0ng!Pass2"
```

Terraform automatically maps any `TF_VAR_<name>` variable to the matching Terraform variable.

---

## Step 7 — Validate, preview, then deploy

Always run these three in order. `validate` is the first real schema check — it downloads the Azure provider and confirms every resource is configured correctly.

```powershell
terraform fmt        # tidy formatting (optional)
terraform validate   # checks the code is correct
terraform plan       # preview: shows everything it will create
```

Read the plan. It should say it will **add** roughly 25–30 resources and change/destroy nothing. When you are happy:

```powershell
terraform apply
```

Type `yes`. This takes ~10–20 minutes (the AKS cluster is the slow part). When it finishes, Terraform prints your outputs — the AKS cluster name, the web app hostname, the SQL server address, and so on.

You now have a full landing zone running. Open the Azure Portal and look at the resource groups (`exco-dev-network-rg`, `-platform-rg`, `-workload-rg`) to see everything Terraform built.

---

## Step 8 — Tear it down when you are done

To stop all charges for an environment, destroy it. This deletes everything Terraform created (but not the bootstrap state storage):

```powershell
terraform destroy
```

Re-running `apply` later rebuilds it from scratch. This create/destroy cycle is the safest way to learn.

---

## Step 9 — Deploy production (when ready)

`prod` works identically. From the repo root:

```powershell
cd environments/prod
# edit terraform.tfvars: set your prod subscription_id
terraform init `
  -backend-config="resource_group_name=exco-tfstate-rg" `
  -backend-config="storage_account_name=excotfstateabc123" `
  -backend-config="container_name=tfstate" `
  -backend-config="key=prod.terraform.tfstate"
# set the two TF_VAR_ passwords again in this terminal
terraform plan
terraform apply
```

Note the different `key=prod.terraform.tfstate` — that is what keeps prod's state separate from dev's. The prod `terraform.tfvars` already requests larger VM sizes, more AKS nodes, and higher database/app tiers.

---

## Common issues

- **"A resource with this name already exists" / name not available** — Key Vault, storage, web app, and SQL names must be globally unique. Re-running usually fixes it (a new random suffix is generated), or change `org` in `terraform.tfvars`.
- **Quota / region errors** — a brand-new subscription may not be allowed to create large VMs. Stick with the `dev` sizes, or request a quota increase in the Portal.
- **`terraform validate` fails** — read the message; it names the file and line. This project was written for `azurerm ~> 4.0`; make sure `init` pulled a 4.x provider.
- **You lost the bootstrap outputs** — find them in the Portal (look for the `-tfstate-rg` resource group) or run `terraform output` inside the `bootstrap/` folder.

---

## Where to go next

1. Change a value in `dev/terraform.tfvars`, run `plan`, and watch what Terraform proposes.
2. Read one module top to bottom (start with `modules/resource-group`).
3. Convert the single VM into a Virtual Machine Scale Set for hands-off scaling.
4. Move deployment into a CI/CD pipeline (GitHub Actions or Azure DevOps) so `plan` runs on every pull request. See `ARCHITECTURE.md` section 9.
