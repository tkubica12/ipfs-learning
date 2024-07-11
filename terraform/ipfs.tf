resource "azurerm_network_interface" "ipfs" {
  count               = var.ipfs_node_count
  name                = "nic-${local.base_name}-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "ipfs" {
  count                           = var.ipfs_node_count
  name                            = "vm-${local.base_name}-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2ads_v5"
  admin_username                  = "tomas"
  admin_password                  = "Azure12345678"
  disable_password_authentication = false
  user_data                       = base64encode(local.install_script)

  network_interface_ids = [
    azurerm_network_interface.ipfs[count.index].id,
  ]

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"

    diff_disk_settings {
      option    = "Local"
      placement = "ResourceDisk"
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }
}
