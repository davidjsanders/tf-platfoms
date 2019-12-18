resource "azurerm_network_security_rule" "dns-demo-nsgrules" {
  count = length(var.nsg-rules)

  name                   = var.nsg-rules.*.name[count.index]
  priority               = "${100 + (count.index)}"
  direction              = var.nsg-rules.*.direction[count.index]
  access                 = var.nsg-rules.*.access[count.index]
  protocol               = var.nsg-rules.*.protocol[count.index]
  source_port_range      = var.nsg-rules.*.source_port_range[count.index]
  destination_port_range = var.nsg-rules.*.destination_port_range[count.index]
  source_address_prefix  = var.nsg-rules.*.source_address_prefix[count.index]

  destination_address_prefix  = azurerm_subnet.dns-demo-subnet.address_prefix
  resource_group_name         = azurerm_resource_group.dns-demo-rg.name
  network_security_group_name = azurerm_network_security_group.dns-demo-nsg.name
}
