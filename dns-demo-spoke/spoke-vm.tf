resource "azurerm_virtual_machine" "dns-demo-vm" {
  count = var.vm-count

  availability_set_id              = ""
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"
  location                         = var.location
  name = upper(
    format(
      "VM-DNS-DEMO-%02d", 
      count.index + 1,
      )
  )

  network_interface_ids = [azurerm_network_interface.dns-demo-nic.*.id[count.index]]
  resource_group_name   = azurerm_resource_group.dns-demo-spoke-rg.name
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
    name = format(
      "OSD-DNS-DEMO-%02d",
      count.index,
    )
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name = upper(format(
      "VM-DNS-DEMO-%02d",
      count.index
    ))
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

