# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      lb-probe.tf
# Environments:   all
# Purpose:        Module to define the Azure load balancer probe
#                 for the cluster load balancer.
#
# -------------------------------------------------------------------

resource "azurerm_lb_probe" "k8s-lb-probes" {
  count = length(var.lb-ports)

  resource_group_name = azurerm_resource_group.k8s-rg.name
  loadbalancer_id     = azurerm_lb.k8s-lb.id
  name                = format(
                          "%s-probe", 
                          var.lb-ports.*.name[count.index]
                        )
  port                = var.lb-ports.*.backend-port[count.index]
}
