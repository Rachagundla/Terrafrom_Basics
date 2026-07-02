resource "azurerm_postgresql_flexible_server" "postgres" {

  name                = "abc-postgres_${var.environment}sql"
  resource_group_name = var.resource_group_name
  location            = var.location
  administrator_login = "dbadmin"
  administrator_password = "Password@123"
  sku_name = "B_Standard_B1ms"
  version = "16"
  storage_mb = 32768
}