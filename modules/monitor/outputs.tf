output "workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "application_insights_key" {
  value = azurerm_application_insights.appinsights.instrumentation_key
  sensitive = true
}