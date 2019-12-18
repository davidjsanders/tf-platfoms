resource "azurerm_public_ip" "dns-demo-pip" {
  allocation_method   = "Static"
  location            = var.location
  name                = "PIP-DNS-DEMO-BASTION"
  resource_group_name = azurerm_resource_group.dns-demo-rg.name
  sku                 = "Basic"

  tags = var.tags
}
