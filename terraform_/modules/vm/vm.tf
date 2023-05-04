resource "azurerm_network_interface" "myNIC" {
  name                = "myNIC"
  location            = var.resource_group_location
  resource_group_name = var.group

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "" {
  name                            = "myLinuxVM"
  availability_set_id             = azurerm_availability_set.avset.id
  location                        = var.resource_group_location
  resource_group_name             = var.group
  network_interface_ids           = element(azurerm_network_interface.myNIC.id)
  size                            = "Standard_D2s_v3"
  computer_name                   = "myvm"
  admin_username                  = "sami"
  admin_password                  = "S@miMvola1234"
  disable_password_authentication = false
  storage_data_disk {
    name              = "datadisk_new_"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "100"
  }

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
