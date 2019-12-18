resource "azurerm_network_interface" "dns-demo-bastion-nic" {
  location            = var.location
  name                = "NIC-DNS-DEMO-BASTION"
  resource_group_name = azurerm_resource_group.dns-demo-rg.name

  ip_configuration {
    name                          = "IPC-DNS-DEMO-BASTION"
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.0.5"
    public_ip_address_id          = azurerm_public_ip.dns-demo-pip.id
    subnet_id                     = azurerm_subnet.dns-demo-subnet.id
  }

  tags       = var.tags
}
