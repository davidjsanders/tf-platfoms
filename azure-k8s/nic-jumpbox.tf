# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      nic-jumpox.tf
# Environments:   all
# Purpose:        Module to define the Azure network interface card
#                 (nic) for the VM Jumpbox.
#
# Created on:     10 September 2019
# Created by:     David Sanders
# Creator email:  dsanderscanada@nospam-gmail.com
#
# -------------------------------------------------------------------
# Modifed On   | Modified By                 | Release Notes
# -------------------------------------------------------------------
# 10 Sep 2019  | David Sanders               | First release.
# -------------------------------------------------------------------

resource "azurerm_network_interface" "k8s-nic-jumpbox" {
  count = var.jumpboxes.vm-count

  location = var.location
  name = format(
    "NIC-JUMPBOX-%02d-%s-%s%s",
    count.index + 1,
    var.target,
    var.environ,
    local.l-random,
  )
  resource_group_name = azurerm_resource_group.k8s-rg.name

  ip_configuration {
    name = format(
      "NIC-JUMPBOX-IPCONFIG-%02d-%s-%s%s",
      count.index,
      var.target,
      var.environ,
      local.l-random,
    )
    private_ip_address_allocation = "Static"
    private_ip_address = cidrhost(
      azurerm_subnet.k8s-subnet-jumpbox.address_prefix,
      5)
    public_ip_address_id          = azurerm_public_ip.k8s-pip-jump.*.id[count.index]
    subnet_id                     = azurerm_subnet.k8s-subnet-jumpbox.id
  }

  tags       = var.tags
  depends_on = [azurerm_subnet.k8s-subnet-jumpbox]
}

