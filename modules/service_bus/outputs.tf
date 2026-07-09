output "namespace_name" {
  value = azurerm_servicebus_namespace.sb.name
}

output "servicebus_id" {
  value = azurerm_servicebus_namespace.sb.id
}