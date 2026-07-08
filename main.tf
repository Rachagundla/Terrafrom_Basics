# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_Name # name     = "rg-dev"
  location = var.rg_Location
}

# #Storage Account names must be globally unique and no hypen,spaces,caps
# resource "azurerm_storage_account" "storage_account" {
#   name                     = var.storage_account_name
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = {
#     environment = var.environment[0]
#   }
# }

# resource "azurerm_storage_container" "storage_container" {
#   name                  = var.storage_container_name
#   storage_account_name  = azurerm_storage_account.storage_account.name
#   container_access_type = "private"
# }

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  environment         = terraform.workspace
}

# module "virtual_machine" {
#   source = "./modules/virtual_machine"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   environment         = terraform.workspace
#   # Implicit Dependency:
#   # The VM module depends on the Network module because it
#   # consumes the subnet_id output from the Network module.
#    subnet_id = module.network.subnet_id

#   # Explicit Dependency:
#   # Ensures the entire Network module completes before
#   # Terraform starts creating resources in the VM module.
#   # This is optional here because the implicit dependency
#   # already exists, but it is useful for learning purposes.
#   depends_on = [
#     module.network
#   ]
# }


module "load_balancer" {
  source = "./modules/load_balancer"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  environment         = terraform.workspace

  # Explicit dependency
  depends_on = [
    module.network,
    # module.virtual_machine
  ]
}



data "azurerm_key_vault" "kv" {
  name                = "abcd-${terraform.workspace}-keyvault"
  resource_group_name = "rg-tfstate"
}

data "azurerm_key_vault_secret" "postgres_admin" {
  name         = "PostgreSQLAdmin"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "postgres_password" {
  name         = "PostgreSQLPassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}

# Database Module where creating the postgresqlDB
module "database" {
  source = "./modules/database"

  resource_group_name               = azurerm_resource_group.rg.name
  location                          = azurerm_resource_group.rg.location
  environment                       = terraform.workspace
  postgresql_administrator_login    = data.azurerm_key_vault_secret.postgres_admin.value
  postgresql_administrator_password = data.azurerm_key_vault_secret.postgres_password.value
}


# Key Vault Module
# module "key_vault" {
#   source = "./modules/key_vault"

#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   environment         = terraform.workspace
#   db_password_name    = var.db_password_name
#   db_password_value   = var.db_password_value
#   tenant_id           = data.azurerm_client_config.current.tenant_id
#   depends_on = [
#     module.database
#   ]

# }


# Service bus
module "service_bus" {
  source = "./modules/service_bus"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  environment         = terraform.workspace
}


# azure kubernet services
module "aks" {

  source = "./modules/aks"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  environment         = terraform.workspace

  depends_on = [
    module.network
  ]
}

# monitor
module "monitor" {
  source = "./modules/monitor"

  resource_group_name = azurerm_resource_group.rg.name
  environment         = terraform.workspace
}

# # Azure Automation Account for testing the github action to run the pipeline
# module "automation" {
#   source              = "./modules/automation_account"
#   resource_group_name = azurerm_resource_group.rg.name
#   environment         = terraform.workspace 
# }
