# Architecture & Concepts (start here)

This guide explains the ideas behind the code. No commands — just the mental model you need before you run anything. If a term is new, it is defined the first time it appears.

## 1. What Terraform actually does

Terraform is a tool for describing cloud infrastructure as text files and then making the cloud match that text. You write *what you want* ("a virtual network, a database, a Kubernetes cluster"), and Terraform figures out the API calls to create, change, or delete resources so that Azure ends up looking like your files. This approach is called **Infrastructure as Code (IaC)**.

Why it matters for a cloud-only company: instead of clicking around the Azure Portal (which nobody can reproduce or review), your entire environment lives in files you can version-control, peer-review, and re-run. Rebuilding your whole platform in a new region becomes "run the code again."

The core loop is three commands you will meet in `GETTING-STARTED.md`:

- `terraform init` — download the plugins needed to talk to Azure.
- `terraform plan` — preview what would change. Nothing happens to Azure yet.
- `terraform apply` — make the changes for real.

Terraform keeps a record of everything it created in a file called **state**. State is how it knows the difference between "this already exists" and "I need to create this." Protecting the state file is a big deal — more on that below.

## 2. The building blocks of the language

You will see four kinds of thing in the `.tf` files:

- **Resource** — one real object in Azure (`azurerm_resource_group`, `azurerm_kubernetes_cluster`). This is the noun Terraform creates.
- **Variable** — an input you can change without editing logic (a region, a VM size). Defined in `variables.tf`, given values in `terraform.tfvars`.
- **Output** — a value Terraform prints after applying (a database hostname, a cluster name), so you or other tools can use it.
- **Module** — a reusable folder of resources you can call many times with different inputs. Think of it as a function: define once, use for `dev` and `prod`.

The `azurerm` in resource names is the **provider** — the plugin that translates Terraform into Azure API calls. This repo pins `azurerm ~> 4.0`, meaning "any 4.x version."

## 3. What a "landing zone" is

A **landing zone** is the pre-built, governed foundation you set up *before* teams start deploying apps — so that everything that lands in your cloud is already networked, secured, monitored, and tagged correctly. It is Microsoft's recommended starting pattern for a company adopting Azure.

You can think of the three roles in your project description mapping onto three layers of the landing zone:

- **Cloud architect** — the shape: how networks, subscriptions, and regions are organized (sections 4 and 5).
- **Systems administrator** — the platform services everything relies on: identity, secrets, monitoring, patching, VMs (section 6).
- **DevOps** — how it all gets deployed repeatably and scales: modules, environments, remote state, and CI/CD (sections 7–9).

## 4. Hub-and-spoke networking

Every resource that talks over the network needs to live in a **virtual network (VNet)** — a private, isolated network inside Azure — carved into **subnets** (smaller address ranges for grouping resources). A **network security group (NSG)** is the firewall that controls what traffic is allowed in and out of a subnet.

This repo uses the standard **hub-and-spoke** topology:

- The **hub** VNet holds shared, central services (in a bigger setup: firewalls, VPN gateways, DNS). It is the front door.
- The **spoke** VNet holds your actual workloads, split into subnets: `apps` (the VM), `aks` (Kubernetes, which needs a large range because every pod gets an IP), and `data` (databases).
- The two are joined by **peering**, a private link so hub and spoke can talk to each other without going over the public internet.

Why not one flat network? Separation. You can apply different security rules per spoke, add more spokes later (one per team or app) without redesigning, and keep shared services in one controlled place. That is exactly what makes it *scalable*.

## 5. Environments and why `dev` and `prod` are separate folders

`dev` (for experimenting and breaking things) and `prod` (real, must-not-break) are deployed from separate folders, each with its **own state** and ideally its own **subscription** (Azure's billing-and-isolation boundary). Separation means a mistake in `dev` can never touch `prod`, and you can give people access to one without the other.

The key trick: **both environments run the exact same module code.** They differ only in `terraform.tfvars`. In `dev` the AKS cluster scales 1–2 small nodes and the database is `Basic`; in `prod` it scales 3–10 larger nodes and the database is bigger. Same blueprint, different dial settings. When you improve a module, both environments benefit, and there is no risk of them drifting apart.

## 6. The platform services (systems-administrator layer)

- **Identity & Key Vault** (`modules/identity`) — a **Key Vault** is Azure's secure store for passwords, keys, and certificates. A **managed identity** lets a workload (say, the web app) authenticate to other Azure services *without any password at all* — Azure hands it a short-lived token. This is the modern, safer alternative to storing credentials.
- **Monitoring** (`modules/monitoring`) — a **Log Analytics workspace** is the central bucket that logs and metrics flow into; **Application Insights** adds application-level telemetry (request rates, errors, latency). Centralizing this means one place to query when something breaks.
- **Governance** (`modules/governance`) — **Azure Policy** enforces rules automatically. The included policy restricts resource creation to approved regions, so nobody accidentally spins up servers in the wrong country. This is how a small team keeps a large cloud footprint compliant.

## 7. How this maps to "scalable"

"Scalable" shows up in three distinct places, and it is worth separating them:

- **Scaling the compute** — AKS uses a **node pool with autoscaling** (add/remove servers based on load), and the production App Service plan (`P1v3`) supports autoscale rules. Traditional VMs scale via a **Virtual Machine Scale Set (VMSS)** — the `virtual-machine` module here is a single VM for clarity, and the natural next step is to convert it to a scale set using the same pattern.
- **Scaling the organization** — the hub-and-spoke + module + environment structure lets you add new spokes, new workloads, and new environments without rewriting anything. That is architectural scalability.
- **Scaling the team** — because everything is code with remote state (next section), multiple people can work safely, review each other's changes, and automate deployment.

## 8. Remote state and the "bootstrap" step

By default Terraform writes its state file to your laptop. That is fine for a solo experiment but wrong for a company: the file can contain secrets, and if two people run Terraform at once they corrupt each other's view of reality.

The fix is **remote state** — store the state file in an Azure Storage account instead, where it is encrypted, versioned, and **locked** (so only one apply runs at a time). But there is a chicken-and-egg problem: Terraform needs somewhere to store state before it can store state. That is what the **`bootstrap/`** folder solves — you run it once, by hand, to create the storage account. Its own tiny state stays local. After that, every environment points its **backend** (the setting that says "keep state here") at that storage account.

## 9. Where CI/CD fits (the DevOps end state)

Running `terraform apply` from your laptop is how you learn. The mature version is a **pipeline** (GitHub Actions or Azure DevOps) that runs `plan` on every pull request and `apply` when a change is merged. That gives you review, an audit trail, and no "works on my machine." This repo is structured to drop straight into that model: each environment folder is a self-contained root you point a pipeline job at. Setting up the pipeline is the recommended follow-up once you are comfortable running Terraform by hand.

## 10. Suggested learning path

1. Read `GETTING-STARTED.md` and deploy `dev`. Break it, fix it, `destroy` it, redeploy.
2. Open one module (`modules/resource-group` is the smallest) and trace how its variables, resources, and outputs connect.
3. Change a value in `dev/terraform.tfvars`, run `plan`, and read what Terraform says it will change.
4. Deploy `prod` and compare the two.
5. Convert the single VM to a scale set, then add a CI/CD pipeline.

Take it one module at a time — you do not need to understand all of it before you deploy.
