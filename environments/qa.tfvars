# QA Environment Variables
# This file contains the input variable values for the QA environment.
# It is used at runtime with:
# terraform apply -var-file="environments/qa.tfvars"

environment = "qa"

rg_Name = "rg-qa"
rg_Location = "centralindia"

storage_account_name = "qastorage001xyz"
storage_container_name = "tfstate"

postgresql_administrator_login = "dbadmin"
postgresql_administrator_password = "Password@123"

db_password_name = "DatabasePassword"
db_password_value = "Password@123"