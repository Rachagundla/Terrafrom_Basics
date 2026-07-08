resource "azurerm_kubernetes_cluster" "aks" {

  name                = "abc-${var.environment}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "abc-${var.environment}"

  default_node_pool {
  name       = "default"
  node_count = 1
  vm_size    = "Standard_B1ms"
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
}