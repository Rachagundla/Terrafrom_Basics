resource "azurerm_key_vault" "vault" {
  name                = "abc-${var.environment}-keyvault"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "standard"
  tenant_id           = var.tenant_id
  enable_rbac_authorization = true
}

resource "azurerm_key_vault_secret" "dbpassword" {
  name         = var.db_password_name
  value        = var.db_password_value
  key_vault_id = azurerm_key_vault.vault.id

}