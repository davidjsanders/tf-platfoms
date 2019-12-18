resource "azurerm_storage_account" "dns-demo-sa" {
  account_tier             = "Standard"
  account_replication_type = "LRS"
  name                     = "dnsdemosa1234"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.dns-demo-rg.name

  tags = var.tags
}

