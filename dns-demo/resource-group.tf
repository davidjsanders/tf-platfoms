resource "azurerm_resource_group" "dns-demo-rg" {
  name     = "RG-DNS-DEMO"
  location = var.location
  tags     = var.tags
}
