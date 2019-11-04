# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      nsg.tf
# Environments:   all
# Purpose:        Module to define the Azure network security group
#                 used by ALL subnets.
#
# -------------------------------------------------------------------

resource "azurerm_network_security_group" "k8s-vnet-nsg" {
  name = format(
    "NSG-%s-%s-%s%s",
    var.nsg-name,
    var.target,
    var.environ,
    local.l-random,
  )
  location            = var.location
  resource_group_name = azurerm_resource_group.k8s-rg.name

  tags = var.tags
}

