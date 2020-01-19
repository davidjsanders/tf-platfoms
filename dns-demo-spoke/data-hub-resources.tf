data "azurerm_virtual_network" "hub-vnet" {
    name                = "VNET-DNS-DEMO"
    resource_group_name = "RG-DNS-DEMO-HUB"
}

data "azurerm_resource_group" "hub-rg" {
    name = "RG-DNS-DEMO-HUB"
}

data "azurerm_storage_account" "dns-demo-sa" {
    name                = "dnsdemosa1234"
    resource_group_name = "RG-DNS-DEMO-HUB"
}

data "azurerm_public_ip" "dns-demo-pip" {
    name                = "PIP-DNS-DEMO-BASTION"
    resource_group_name = "RG-DNS-DEMO-HUB"
}

data "azurerm_virtual_machine" "dns-demo-bastion" {
    name                = "VM-DNS-DEMO-BASTION"
    resource_group_name = "RG-DNS-DEMO-HUB"
}