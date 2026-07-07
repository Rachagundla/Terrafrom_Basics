resource "azurerm_servicebus_namespace" "sb" {
  name                = "abc-${var.environment}-servicebus"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "orders" {
  name         = "orders"
  namespace_id = azurerm_servicebus_namespace.sb.id
  #   auto_delete_on_idle = "P7D"
  # default_message_ttl = "P14D"
  # duplicate_detection_history_time_window = "PT10M"
}