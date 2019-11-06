# -------------------------------------------------------------------
#
# Module:         tf-platforms/azure-k8s-ansible
# Submodule:      vm-jumpox.tf
# Environments:   all
# Purpose:        Module to define the Azure virtual machine for the
#                 jumpbox.
#
# -------------------------------------------------------------------

resource "azurerm_virtual_machine" "vm-master" {
  depends_on = [
    "azurerm_network_interface.k8s-nic-master"
  ]

  availability_set_id              = azurerm_availability_set.k8s-avset-mgr.id
  delete_os_disk_on_termination    = var.masters.delete_os
  delete_data_disks_on_termination = var.masters.delete_data
  location                         = var.location
  name = upper(
    format(
      "VM-MTR-1-%s-%s%s", 
      var.target, 
      var.environ, 
      local.l-random
    ),
  )
  network_interface_ids = [azurerm_network_interface.k8s-nic-master.id]
  resource_group_name   = azurerm_resource_group.k8s-rg.name
  vm_size               = var.masters.vm-size

  boot_diagnostics {
    storage_uri = azurerm_storage_account.k8s-sa-boot-diag.primary_blob_endpoint
    enabled     = true
  }

  storage_image_reference {
    id = format(
      "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Compute/images/%s",
      var.subscription_id,
      var.masters.image-rg,
      var.masters.image-id
    )
  }

  storage_os_disk {
    name              = format("OSD-MTR-1-%s-%s%s", var.target, var.environ, local.l-random)
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.vm-osdisk-type
  }

  storage_data_disk {
    name            = data.azurerm_managed_disk.datasourcemd.name
    managed_disk_id = data.azurerm_managed_disk.datasourcemd.id
    create_option   = "Attach"
    lun             = "0"
    disk_size_gb    = data.azurerm_managed_disk.datasourcemd.disk_size_gb
  }

  os_profile {
    computer_name = upper(
      format(
        "%s",
        var.masters.prefix
      ),
    )
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

