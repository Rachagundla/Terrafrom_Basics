terraform {
  backend "azurerm" {
    resource_group_name  = "rg-dev"
    storage_account_name = "pavandevstorage001"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}