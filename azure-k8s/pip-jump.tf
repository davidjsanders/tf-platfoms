# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      pip-jump.tf
# Environments:   all
# Purpose:        Module to define the Azure jumpbox puplic IP.
#
# -------------------------------------------------------------------

resource "azurerm_public_ip" "k8s-pip-jump" {
  count = local.l_jumpboxes_vm_count

  allocation_method = "Static"
  location          = var.location
  name = format(
    "PIP-%s-JUMP-%02d-%s-%s%s",
    var.vnet-name,
    count.index + 1,
    var.target,
    var.environ,
    local.l-random,
  )
  resource_group_name = azurerm_resource_group.k8s-rg.name
  sku                 = "Basic"

  tags = var.tags
}
