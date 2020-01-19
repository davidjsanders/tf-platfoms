resource "azurerm_virtual_network" "dns-demo-spoke-vnet" {
  address_space       = ["192.168.1.0/26"]
  location            = var.location
  name                = "VNET-DNS-DEMO-SPOKE"
  resource_group_name = azurerm_resource_group.dns-demo-spoke-rg.name
  tags                = var.tags

  dns_servers = ["192.168.0.5"]
}
