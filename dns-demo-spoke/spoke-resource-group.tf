resource "azurerm_resource_group" "dns-demo-spoke-rg" {
  name     = "RG-DNS-DEMO-SPOKE"
  location = var.location
  tags     = var.tags
}
