resource "azurerm_virtual_network" "dns-demo-vnet" {
  address_space       = ["192.168.0.0/16"]
  location            = var.location
  name                = "VNET-DNS-DEMO"
  resource_group_name = azurerm_resource_group.dns-demo-rg.name
  tags                = var.tags

  dns_servers = ["192.168.0.40"]
}

