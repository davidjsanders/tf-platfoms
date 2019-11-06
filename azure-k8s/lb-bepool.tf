# -------------------------------------------------------------------
#
# Module:         tf-platforms/azure-k8s-ansible
# Submodule:      lb-rule.tf
# Environments:   all
# Purpose:        Module to define the Azure load balancer backend
#                 for the cluster load balancer.
#
# -------------------------------------------------------------------

resource "azurerm_lb_backend_address_pool" "k8s-lb-bepool" {
  resource_group_name = azurerm_resource_group.k8s-rg.name
  loadbalancer_id     = azurerm_lb.k8s-lb.id
  name                = "BackEndAddressPool"
}

