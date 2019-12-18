resource "azurerm_resource_group" "dns-demo-rg" {
  name     = "RG-DNS-DEMO-HUB"
  location = var.location
  tags     = var.tags
}
