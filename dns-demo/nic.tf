resource "azurerm_network_interface" "dns-demo-nic" {
  count = var.vm-count

  location            = var.location
  name = format(
    "NIC-DNS-DEMO-%02d",
    count.index
  )

  resource_group_name = azurerm_resource_group.dns-demo-rg.name

  # internal_dns_name_label = "davidtest.internal.cloudapp.net"

  ip_configuration {
    name = format(
      "IPC-DNS-DEMO-%02d",
      count.index
    )

    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(
      azurerm_subnet.dns-demo-subnet.address_prefix,
      5 + count.index)
    subnet_id                     = azurerm_subnet.dns-demo-subnet.id
  }

  tags       = var.tags
}
