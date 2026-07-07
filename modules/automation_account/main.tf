resource "azurerm_automation_account" "test" {
  name                = "aa-${var.environment}-github"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
}