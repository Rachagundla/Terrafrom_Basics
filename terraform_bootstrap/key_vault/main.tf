resource "azurerm_key_vault" "vault" {
  name                = "abcd-${var.environment}-keyvault"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "standard"
  tenant_id           = var.tenant_id
  rbac_authorization_enabled = true
}

resource "azurerm_key_vault_secret" "dbpassword" {
  name         = "DatabasePassword"
  value        = var.db_password_value
  key_vault_id = azurerm_key_vault.vault.id

}


resource "azurerm_key_vault_secret" "postgres_admin" {
  name         = "PostgreSQLAdmin"
  value        = var.postgres_admin_name
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "PostgreSQLPassword"
  value        = var.postgres_admin_password
  key_vault_id = azurerm_key_vault.vault.id
}