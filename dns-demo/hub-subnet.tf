resource "azurerm_subnet" "dns-demo-subnet" {
  address_prefix = "192.168.0.0/29"

  name                      = "SNET-DNS-DEMO"
  resource_group_name       = azurerm_resource_group.dns-demo-rg.name
  virtual_network_name      = azurerm_virtual_network.dns-demo-vnet.name
  network_security_group_id = azurerm_network_security_group.dns-demo-nsg.id
}
