===========================================================
Terraform Commands Cheat Sheet
===========================================================

# Initialize Terraform
terraform init

# Format Terraform files
terraform fmt

# Validate Terraform configuration
terraform validate

# Show execution plan
terraform plan

# Create resources
terraform apply

# Create resources without confirmation
terraform apply -auto-approve

# Destroy resources
terraform destroy

# Destroy resources without confirmation
terraform destroy -auto-approve

# Show Terraform version
terraform version

# Show current state resources
terraform state list

# Show current workspace
terraform workspace show

# List all workspaces
terraform workspace list

# Create a workspace
terraform workspace new dev
terraform workspace new test
terraform workspace new uat
terraform workspace new prod

# Switch workspace
terraform workspace select dev

# Delete workspace
terraform workspace delete dev


# Configuring and assigning the tfvar file at runtime
terraform plan -var-file="environments/dev.tfvars"


===========================================================
Terraform State
===========================================================

Terraform stores information about all managed resources in a
State File (terraform.tfstate).

The state file contains:

• Resource IDs
• Resource properties
• Resource dependencies
• Outputs
• Metadata

Terraform uses the state file to compare:

Desired State (.tf files)
            VS
Current State (Azure Resources)

===========================================================
Terraform Workspaces
===========================================================

Each workspace has its own Terraform state.

Example:

default
dev
test
uat
prod

Each workspace can deploy the same Terraform code
without affecting the others.

Example:

terraform workspace new dev
terraform workspace select dev

terraform apply

Creates:

RG-dev
VNet-dev
VM-dev

Switch to:

terraform workspace select prod

terraform apply

Creates:

RG-prod
VNet-prod
VM-prod

===========================================================
Common Recovery Commands
===========================================================

# Remove Terraform cache
rmdir /s /q .terraform

# Remove provider lock file
del .terraform.lock.hcl

# Remove local state files
del terraform.tfstate
del terraform.tfstate.backup
del errored.tfstate

# Re-download providers
terraform init

===========================================================
Useful Commands
===========================================================

# Show outputs
terraform output

# Show providers
terraform providers

# Show current state
terraform show

# Refresh state
terraform refresh

# Unlock state (only if lock exists)
terraform force-unlock LOCK_ID

===========================================================
Terraform Workflow
===========================================================

terraform init
        ↓
terraform fmt
        ↓
terraform validate
        ↓
terraform plan
        ↓
terraform apply
        ↓
Verify Resources in Azure
        ↓
terraform destroy









# Terraform CI/CD using GitHub Actions with Azure OIDC

## Overview

This project uses **GitHub Actions** to automatically deploy Terraform infrastructure to Azure using **OpenID Connect (OIDC)** authentication.

Instead of storing Azure Client Secrets in GitHub, GitHub Actions authenticates securely with Azure through Microsoft Entra ID.

---

# CI/CD Flow

```
Developer
    │
    ▼
Git Push / Pull Request
    │
    ▼
GitHub Actions
    │
    ▼
Azure Login (OIDC)
    │
    ▼
Terraform Init
    │
    ▼
Terraform Validate
    │
    ▼
Terraform Plan
    │
    ▼
Terraform Apply
    │
    ▼
Azure Infrastructure
```

---



# Azure OIDC Configuration

## Step 1

Create an App Registration in Microsoft Entra ID.

Save the following values:

- Application (Client) ID
- Directory (Tenant) ID

---

## Step 2

Create Service Principal

```bash
az ad sp create --id <ApplicationID>
```

---

## Step 3

Assign Contributor Role

```bash
az role assignment create \
--assignee <ApplicationID> \
--role Contributor \
--scope /subscriptions/<SubscriptionID>
```

---

## Step 4

Configure Federated Credential

Azure Portal

```
Microsoft Entra ID

↓

App Registrations

↓

github-terraform

↓

Certificates & Secrets

↓

Federated Credentials

↓

Add Credential
```

Choose

```
GitHub Actions Deploying Azure Resources
```

Provide

- GitHub Organization
- Repository Name
- Branch = main

Azure automatically creates

```
Issuer

https://token.actions.githubusercontent.com

Subject

repo:<username>/<repository>:ref:refs/heads/main
```

---

# GitHub Secrets

Navigate to

```
Repository

↓

Settings

↓

Secrets and Variables

↓

Actions
```

Create the following secrets.

| Secret | Description |
|---------|-------------|
| AZURE_CLIENT_ID | Application (Client) ID |
| AZURE_TENANT_ID | Tenant ID |
| AZURE_SUBSCRIPTION_ID | Azure Subscription ID |

**Note**

No Client Secret is required because authentication uses OIDC.

---

# GitHub Actions Workflows

Create the following folder.

```
.github/

└── workflows/
```

---

# terraform-plan.yml

Purpose

Runs whenever a Pull Request is created against the **main** branch.

Workflow

```
Pull Request

↓

Checkout Repository

↓

Azure Login (OIDC)

↓

Terraform Init

↓

Terraform Format Check

↓

Terraform Validate

↓

Terraform Plan
```

### terraform-plan.yml

```yaml
name: Terraform Plan

on:
  pull_request:
    branches:
      - main

permissions:
  id-token: write
  contents: read

jobs:
  terraform-plan:
    runs-on: ubuntu-latest

    steps:

      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Install Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Azure Login using OIDC
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Terraform Init
        run: terraform init

      - name: Terraform Format Check
        run: terraform fmt -check

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan -var-file="environments/dev.tfvars"
```

---

# terraform-apply.yml

Purpose

Runs automatically whenever code is merged into the **main** branch.

Workflow

```
Push to main

↓

Checkout Repository

↓

Azure Login

↓

Terraform Init

↓

Terraform Apply

↓

Azure Infrastructure Updated
```

### terraform-apply.yml

```yaml
name: Terraform Apply

on:
  push:
    branches:
      - main

permissions:
  id-token: write
  contents: read

jobs:
  terraform-apply:
    runs-on: ubuntu-latest

    steps:

      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Install Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Azure Login using OIDC
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Terraform Init
        run: terraform init

      - name: Terraform Apply
        run: terraform apply -auto-approve -var-file="environments/dev.tfvars"
```

---

# Expected Behavior

## Pull Request

```
terraform fmt

↓

terraform init

↓

terraform validate

↓

terraform plan
```

No infrastructure changes are made.

---

## Merge into Main

```
terraform init

↓

terraform apply

↓

Azure Infrastructure Updated
```

New resources are created or existing resources are updated automatically.

---

# Advantages of OIDC

- No Client Secret stored in GitHub
- Secure authentication
- Temporary access tokens
- Microsoft recommended approach
- Enterprise best practice

---

# Future Improvements

- Add GitHub Environments (Dev, QA, UAT, Prod)
- Configure Manual Approval Gates
- Store Terraform Plan as an Artifact
- Apply Approved Plan Only
- Add Terraform Destroy Workflow
- Add Security Scanning (Checkov/Tfsec)
- Add Terraform Documentation Generation
- Add Notifications (Teams/Slack/Email)

---

# Summary

This CI/CD pipeline enables automatic deployment of Terraform infrastructure to Azure using GitHub Actions and OIDC authentication.

**Pull Request**

- Checkout Code
- Azure Login
- Terraform Init
- Terraform Validate
- Terraform Plan

**Merge to Main**

- Checkout Code
- Azure Login
- Terraform Init
- Terraform Apply

This approach follows modern Azure DevOps and Infrastructure as Code best practices.