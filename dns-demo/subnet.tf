resource "azurerm_subnet" "dns-demo-subnet" {
  address_prefix = cidrsubnet(
    azurerm_virtual_network.dns-demo-vnet.address_space[0], 
    10, 
    0
  )

  name                      = "SNET-DNS-DEMO"
  resource_group_name       = azurerm_resource_group.dns-demo-rg.name
  virtual_network_name      = azurerm_virtual_network.dns-demo-vnet.name
  network_security_group_id = azurerm_network_security_group.dns-demo-nsg.id
}

