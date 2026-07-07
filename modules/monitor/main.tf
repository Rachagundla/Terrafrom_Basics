resource "azurerm_monitor_action_group" "actiongroup" {
  name                = "alerts"
  short_name          = "alerts"
  resource_group_name = var.resource_group_name
}