resource "azurerm_cdn_frontdoor_profile" "frontdoor" {
    
  name                = "abc-${var.environment}-fd"
  resource_group_name = var.resource_group_name
  sku_name = "Standard_AzureFrontDoor"
}