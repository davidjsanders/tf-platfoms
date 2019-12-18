resource "azurerm_virtual_machine" "dns-demo-bastion" {
  availability_set_id              = ""
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"
  location                         = var.location
  name                             = "VM-DNS-DEMO-BASTION"

  network_interface_ids = [azurerm_network_interface.dns-demo-bastion-nic.id]
  resource_group_name   = azurerm_resource_group.dns-demo-rg.name
  vm_size               = "Standard_DS1_v2"

  boot_diagnostics {
    storage_uri = azurerm_storage_account.dns-demo-sa.primary_blob_endpoint
    enabled     = true
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "OSD-DNS-DEMO-BASTION"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name = "VM-DNS-DEMO-BASTION"
    admin_username = "superuser"
    admin_password = ""
    custom_data    = ""
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/superuser/.ssh/authorized_keys"
      key_data = var.private-key-pub
    }
  }

  tags = var.tags
}

