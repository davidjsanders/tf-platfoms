# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      data-hosts-file.tf
# Environments:   all
# Purpose:        Module to get the persistent Azure managed disks.
#
# -------------------------------------------------------------------

# Compute and interpolate the variables required for the hosts file
data "template_file" "template-bootstrap" {
  template = file("bootstrap.sh")

  vars = {
    notification_text   = format(
      "Setting up %01d master(s), %01d workers (minimum is 2) and %01d jumpbox(es) (minimum is 1)",
      var.masters.vm-count,
      local.l_workers_vm_count,
      local.l_jumpboxes_vm_count
    )
    jumpbox_user        = var.jumpbox_username
    jumpbox_password    = var.jumpbox_password
    jumpbox_domain_name = var.jumpbox_domain_name
    jumpbox_ip_address  = azurerm_public_ip.k8s-pip-jump.*.ip_address[0]
    wild_user           = var.wild_username
    wild_password       = var.wild_password
    wild_domain_name    = var.ddns_domain_name
    wild_ip_address     = azurerm_public_ip.k8s-pip-lb.ip_address
  }
}

