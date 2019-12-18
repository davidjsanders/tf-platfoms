resource "azurerm_subnet" "dns-demo-subnet" {
  address_prefix = "192.168.1.0/28"

  name                      = "SNET-DNS-DEMO-SPOKE"
  resource_group_name       = azurerm_resource_group.dns-demo-spoke-rg.name
  virtual_network_name      = azurerm_virtual_network.dns-demo-spoke-vnet.name
}
