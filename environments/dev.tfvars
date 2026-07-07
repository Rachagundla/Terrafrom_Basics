# ============================================================================
# Development Environment Variables
# ============================================================================
# This file contains the input variable values for the Development environment.
# Terraform reads the values from this file at runtime when it is specified
# using the -var-file option.
#
# Example:
# terraform plan  -var-file="environments/dev.tfvars"
# terraform apply -var-file="environments/dev.tfvars"
#
# This allows the same Terraform code to be reused for multiple environments
# (Dev, Test, QA, UAT, and Prod) by supplying different values.
# ============================================================================

# Example:
rg_Name                           = "rg-dev"
rg_Location                       = "Central India"
storage_account_name              = "pavandevstorage001"
postgresql_administrator_login    = "dbadmin"
postgresql_administrator_password = "Password@123"
db_password_name                  = "DatabasePassword"
db_password_value                 = "Password@123"
# vm_size              = "Standard_B1s"