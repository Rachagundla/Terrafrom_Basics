# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_Name # name     = "rg-dev"
  location = var.rg_Location
}

#Storage Account names must be globally unique and no hypen,spaces,caps
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment[0]
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}


module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  environment         = terraform.workspace
}

module "virtual_machine" {
  source = "./modules/virtual_machine"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network.subnet_id
  environment         = terraform.workspace
}
