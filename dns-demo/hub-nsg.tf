resource "azurerm_network_security_group" "dns-demo-nsg" {
  name                = "NSG-DNS-DEMO"
  location            = var.location
  resource_group_name = azurerm_resource_group.dns-demo-rg.name

  tags = var.tags
}

