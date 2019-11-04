# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      data-hosts-file.tf
# Environments:   all
# Purpose:        Module to get the persistent Azure managed disks.
#
# -------------------------------------------------------------------

# Compute and interpolate the variables required for the hosts file
data "template_file" "template-hosts-file" {
  template = file("template-data/hosts")

  vars = {
    master  = format(
      "%s    %s",
      azurerm_network_interface.k8s-nic-master.private_ip_address,
      var.masters.prefix
    )
    jumpboxes = join(
      "\n",
      [
        for i in range(0, local.l_jumpboxes_vm_count) : 
          format(
            "%s    %s-%01d",
            azurerm_network_interface.k8s-nic-jumpbox.*.private_ip_address[i],
            var.jumpboxes.prefix,
            i+1
          )
      ]
    )
    workers = join(
      "\n",
      [
        for i in range(0, local.l_workers_vm_count) : 
          format(
            "%s    %s-%01d",
            azurerm_network_interface.k8s-nic-workers.*.private_ip_address[i],
            var.workers.prefix,
            i+1
          )
      ]
    )
  }
}

