resource "azurerm_automation_account" "test" {
  name                = "aa-${var.environment}-github"
  location            = "East US 2"
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
}