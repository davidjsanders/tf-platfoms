# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      resource-group.tf
# Environments:   all
# Purpose:        Module to define the Azure Resource Group used to
#                 contain all resources.
#
# -------------------------------------------------------------------

resource "azurerm_resource_group" "k8s-rg" {
  name = format(
    "RG-%s-%s-%s%s",
    var.resource-group-name,
    var.target,
    var.environ,
    local.l-random,
  )
  location = var.location
  tags     = var.tags
}

