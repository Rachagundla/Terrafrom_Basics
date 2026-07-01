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