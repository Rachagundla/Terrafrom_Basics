resource "azurerm_resource_group" "backend" {
  name     = "rg-tfstate"
  location = "Central India"
}

resource "azurerm_storage_account" "backend" {
  name                = "pavantfstate001" # Change if already taken
  resource_group_name = azurerm_resource_group.backend.name
  location            = azurerm_resource_group.backend.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "backend" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.backend.id
  container_access_type = "private"
}


module "key_vault" {
  source = "./key_vault"

  resource_group_name     = azurerm_resource_group.backend.name
  location                = azurerm_resource_group.backend.location
  environment             = var.environment
  db_password_name        = "DatabasePassword"
  db_password_value       = "Password@123"
  postgres_admin_name     = var.postgres_admin_name
  postgres_admin_password = var.postgres_admin_password
  tenant_id               = data.azurerm_client_config.current.tenant_id
}