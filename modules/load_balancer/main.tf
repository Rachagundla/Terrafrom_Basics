# Public IP
resource "azurerm_public_ip" "lb_pip" {
  name                = "pip-lb-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "lb" {
  name                = "lb-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

# Backend Pool
resource "azurerm_lb_backend_address_pool" "backend" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackendPool"
}

# Health Probe
resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "http-probe"
  protocol        = "Tcp"
  port            = 80
}

# Load Balancing Rule
resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.backend.id
  ]
  probe_id = azurerm_lb_probe.probe.id
}