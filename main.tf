# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_Name # name     = "rg-dev"
  location = var.rg_Location
}

#Storage Account names must be globally unique and no hypen,spaces,caps
resource "azurerm_storage_account" "storageAccount" {
  name                     = var.storage-account-name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment[0]
  }
}