# Azure Landing Zone (Terraform)

A production-style, modular Terraform setup for running a cloud-only company on Microsoft Azure. It covers the ground a systems administrator, cloud architect, and DevOps engineer each care about: networking, identity, governance, monitoring, and four kinds of workload (VMs, Kubernetes, web apps, and SQL databases).

**You are new to Terraform.** Read the two guides in this order:

1. **`ARCHITECTURE.md`** — what Terraform is, what a "landing zone" is, and why this repo is laid out the way it is. Concepts first, no commands.
2. **`GETTING-STARTED.md`** — a copy-paste walkthrough from an empty laptop to a deployed `dev` environment, then `prod`.

## What gets built

Each environment (`dev`, `prod`) deploys:

- Three resource groups: `network`, `platform`, `workload`
- A hub-and-spoke virtual network with subnets and a network security group
- A Log Analytics workspace + Application Insights (central monitoring)
- A Key Vault + managed identity (secrets and passwordless auth)
- A governance policy (restrict resources to approved regions)
- A Linux VM, an autoscaling AKS cluster, a Linux Web App, and an Azure SQL database

## Layout

```
azure-landing-zone/
├── bootstrap/          Run ONCE to create remote-state storage
├── modules/            Reusable building blocks (the "how")
│   ├── resource-group/
│   ├── networking/
│   ├── identity/
│   ├── governance/
│   ├── monitoring/
│   ├── virtual-machine/
│   ├── aks/
│   ├── web-app/
│   └── sql-database/
└── environments/       One folder per environment (the "what")
    ├── dev/
    └── prod/
```

Modules define *how* a thing is built. Environments decide *what* to build and *how big*. `dev` and `prod` share identical module code and differ only in their `terraform.tfvars` (sizes, counts, SKUs) — that is the whole point of the structure.

## Requirements

- An Azure account and subscription
- Terraform >= 1.6 and the Azure CLI (installation covered in `GETTING-STARTED.md`)
- Provider: `hashicorp/azurerm ~> 4.0`

## Safety notes

- Never commit `*.tfstate` or real passwords. The included `.gitignore` blocks them.
- Passwords are passed through environment variables (`TF_VAR_...`), not stored in files.
- This will create billable Azure resources. Run `terraform destroy` to tear an environment down when you are done experimenting.
