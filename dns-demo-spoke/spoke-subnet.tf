resource "azurerm_subnet" "dns-demo-subnet" {
  address_prefix = "192.168.0.16/28"

  name                      = "SNET-DNS-DEMO-SPOKE"
  resource_group_name       = data.azurerm_resource_group.hub-rg.name
  virtual_network_name      = data.azurerm_virtual_network.hub-vnet.name
  # virtual_network_name      = azurerm_virtual_network.dns-demo-spoke-vnet.name
}
