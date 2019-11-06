# -------------------------------------------------------------------
#
# Module:         tf-platforms/azure-k8s-ansible
# Submodule:      vnet.tf
# Environments:   all
# Purpose:        Module to define the Azure virtual network used by
#                 master, minions and load balancers.
#
# -------------------------------------------------------------------

resource "azurerm_virtual_network" "k8s-vnet" {
  address_space = [var.vnet-cidr]
  location      = var.location
  name = upper(
    format(
      "VNET-%s-%s-%s%s",
      var.vnet-name,
      var.target,
      var.environ,
      local.l-random,
    ),
  )
  resource_group_name = azurerm_resource_group.k8s-rg.name

  tags = var.tags
}

