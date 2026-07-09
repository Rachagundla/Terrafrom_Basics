# Action Group
resource "azurerm_monitor_action_group" "actiongroup" {
  name                = "alerts"
  short_name          = "alerts"
  resource_group_name = var.resource_group_name
}

resource "azurerm_monitor_action_group" "email" {
  name                = "CriticalAlerts"
  short_name          = "Critical"
  resource_group_name = var.resource_group_name
  email_receiver {
    name          = "Admin"
    email_address = var.alert_email
  }
}


# Log Analytics
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


# Application Insights
resource "azurerm_application_insights" "appinsights" {

  name                = "appi-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id = azurerm_log_analytics_workspace.law.id
  application_type = "web"
}




# PostgreSQL Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "postgres" {
  name = "postgres-diagnostics"
  target_resource_id = var.postgres_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  enabled_log {
    category = "PostgreSQLLogs"
  }
  metric {
    category = "AllMetrics"
  }
}


# PostgreSQL CPU Alert
resource "azurerm_monitor_metric_alert" "postgres_cpu" {
  name                = "PostgresCPUAlert"
  resource_group_name = var.resource_group_name
  scopes = [
      var.postgres_id
  ]
  description = "CPU greater than 80 percent"
  severity = 2
  frequency = "PT5M"
  window_size = "PT5M"
  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name = "cpu_percent"
    aggregation = "Average"
    operator = "GreaterThan"
    threshold = 80
  }
  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}


# Keyvault diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name = "kv-diagnostics"
  target_resource_id = var.keyvault_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  enabled_log {
    category = "AuditEvent"
  }
  metric {
    category = "AllMetrics"
  }
}



# servicebus diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "servicebus" {
  name = "sb-diagnostics"
  target_resource_id = var.servicebus_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  enabled_log {
    category = "OperationalLogs"
  }
  metric {

    category = "AllMetrics"
  }
}