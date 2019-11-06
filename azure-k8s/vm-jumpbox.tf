# -------------------------------------------------------------------
#
# Module:         tf-platforms/azure-k8s-ansible
# Submodule:      vm-jumpox.tf
# Environments:   all
# Purpose:        Module to define the Azure virtual machine for the
#                 jumpbox.
#
# -------------------------------------------------------------------

resource "azurerm_virtual_machine" "vm-jumpbox" {
  count = local.l_jumpboxes_vm_count

  depends_on = [
    "azurerm_network_interface.k8s-nic-jumpbox"
  ]

  availability_set_id              = ""
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"
  location                         = var.location
  name = upper(
    format(
      "VM-JUMP-%s-%02d-%s%s", 
      var.target, 
      count.index + 1,
      var.environ, 
      local.l-random
      )
  )
  network_interface_ids = [azurerm_network_interface.k8s-nic-jumpbox.*.id[count.index]]
  resource_group_name   = azurerm_resource_group.k8s-rg.name
  vm_size               = var.jumpbox-vm-size

  boot_diagnostics {
    storage_uri = azurerm_storage_account.k8s-sa-boot-diag.primary_blob_endpoint
    enabled     = true
  }

  storage_image_reference {
    id = format(
      "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Compute/images/%s",
      var.subscription_id,
      var.jumpboxes.image-rg,
      var.jumpboxes.image-id
    )
  }

  storage_os_disk {
    name = format(
      "OSD-JUMPBOX-%s-%s%s",
      var.target,
      var.environ,
      local.l-random,
    )
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.vm-osdisk-type
  }

  os_profile {
    computer_name = upper(format(
      "%s",
      var.vm-jumpbox-name
    ))
    admin_username = var.vm-adminuser
    admin_password = var.vm-adminpass
    custom_data    = ""
  }

  os_profile_linux_config {
    disable_password_authentication = var.vm-disable-password-auth

    ssh_keys {
      path     = "/home/${var.vm-adminuser}/.ssh/authorized_keys"
      key_data = var.private-key-pub
    }
  }

  tags = var.tags
}

