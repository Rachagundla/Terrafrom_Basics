resource "azurerm_public_ip" "public_ip" {
  name                = "pip-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_virtual_machine" "vm" {
  name                = "vm-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_size             = "Standard_B1s"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]


  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }

  # Other VM properties...
}