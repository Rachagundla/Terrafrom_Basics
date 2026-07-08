# Production Environment Variables
# This file contains the input variable values for the Production environment.
# It is used at runtime with:
# terraform apply -var-file="environments/prod.tfvars"

environment = "prod"

rg_Name = "rg-prod"
rg_Location = "centralindia"

storage_account_name = "prodstorage001xyz"
storage_container_name = "tfstate"

postgresql_administrator_login = "dbadmin"
postgresql_administrator_password = "Password@123"

db_password_name = "DatabasePassword"
db_password_value = "Password@123"