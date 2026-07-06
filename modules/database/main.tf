# postgresql creation on azure
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = "abc-postgres-${var.environment}sql"
  resource_group_name = var.resource_group_name
  location            = var.location
  administrator_login = var.postgresql_administrator_login
  administrator_password = var.postgresql_administrator_password
  sku_name = "B_Standard_B1ms"
  version = "16"
  storage_mb = 32768
  zone = "1"
}



# cosmosDB creation on azure
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = "abc-${var.environment}-cosmosdb"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type = "Standard"
  kind = "GlobalDocumentDB"
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    location = var.location
    failover_priority = 0
  }
}


# # Redis cache creation on azure
# resource "azurerm_redis_cache" "redis" {
#   name                = "abc-${var.environment}-redis"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   capacity = 0
#   family = "C"
#   sku_name = "Basic"
# }