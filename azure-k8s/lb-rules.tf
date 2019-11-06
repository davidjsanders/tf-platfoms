# -------------------------------------------------------------------
#
# Module:         tf-platforms/azure-k8s-ansible
# Submodule:      lb-rule.tf
# Environments:   all
# Purpose:        Module to define the Azure load balancer rules
#                 for the cluster load balancer.
#
# -------------------------------------------------------------------

resource "azurerm_lb_rule" "k8s-lb-rule-80" {
  count = length(var.lb-ports)

  resource_group_name = azurerm_resource_group.k8s-rg.name
  loadbalancer_id     = azurerm_lb.k8s-lb.id
  name                = var.lb-ports.*.name[count.index]
  protocol            = var.lb-ports.*.protocol[count.index]
  frontend_port       = var.lb-ports.*.frontend-port[count.index]
  backend_port        = var.lb-ports.*.backend-port[count.index]
  frontend_ip_configuration_name = upper(
    format(
      "%s-FE-PIP-%s-%s%s",
      var.lb-name,
      var.target,
      var.environ,
      local.l-random,
    ),
  )
  backend_address_pool_id = azurerm_lb_backend_address_pool.k8s-lb-bepool.id
  probe_id                = azurerm_lb_probe.k8s-lb-probes.*.id[count.index]
}
