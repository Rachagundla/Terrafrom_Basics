resource "azurerm_linux_function_app" "function" {
  name                = "abc-${var.environment}-function"
  location            = var.location
  resource_group_name = var.resource_group_name

  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_key

  site_config {}
}