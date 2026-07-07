resource "azurerm_kubernetes_cluster" "aks" {

  name                = "abc-${var.environment}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_prefix = "abcaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s_v2"
  }

  identity {
    type = "SystemAssigned"
  }
} 