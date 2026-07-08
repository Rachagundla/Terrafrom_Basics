# UAT Environment Variables
# This file contains the input variable values for the UAT environment.
# It is used at runtime with:
# terraform apply -var-file="environments/uat.tfvars"

environment = "uat"

rg_Name = "rg-uat"
rg_Location = "centralindia"

storage_account_name = "uatstorage001xyz"
storage_container_name = "tfstate"

postgresql_administrator_login = "dbadmin"
postgresql_administrator_password = "Password@123"

db_password_name = "DatabasePassword"
db_password_value = "Password@123"