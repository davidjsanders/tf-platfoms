# TODO: Add the curl to the API on the remote to get
#       the DNS suffix for the VNET on creation; otherwise
#       code fails first time it's run (because you can't
#       know an env. var. before the resource is created!)

resource "null_resource" "bastion-provisioner" {
  triggers = {
    bastion-vm = azurerm_virtual_machine.dns-demo-bastion.id
  }

  connection {
    host         = azurerm_public_ip.dns-demo-pip.ip_address
    type         = "ssh"
    user         = "superuser"
    private_key  = var.private-key
  }

  provisioner "file" {
    content      = var.private-key
    destination = "/home/superuser/.ssh/azure_pk"
  }

  provisioner "file" {
    content      = var.private-key-pub
    destination = "/home/superuser/.ssh/azure_pk.pub"
  }

  provisioner "file" {
    source      = "templates/etc-default-bind9"
    destination = "/tmp/bind9"
  }

  provisioner "file" {
    source      = "templates/etc-bind-named-conf-options"
    destination = "/tmp/named.conf.options"
  }

  provisioner "file" {
    source      = "templates/etc-resolv-conf"
    destination = "/tmp/resolv.conf"
  }

  # provisioner "local-exec" {
  #   command = "echo -n 'search ' | tee /tmp/dns-suffix.tmp; az network nic show --ids ${azurerm_network_interface.dns-demo-bastion-nic.id} --resource-group ${azurerm_resource_group.dns-demo-rg.name} | jq -r '.dnsSettings.internalDomainNameSuffix' | tee -a /tmp/dns-suffix.tmp"
  #   interpreter = ["/usr/local/bin/bash", "-c"]
  # }

  provisioner "remote-exec" {
    inline = [
      "touch ~/test.txt",
      "chmod 0600 ~/.ssh/azure_pk",
      "echo 'nameserver 8.8.8.8' | sudo tee /etc/resolv.conf",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=\"--force-confold\" update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=\"--force-confold\" upgrade --yes",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=\"--force-confold\" install --yes bind9 bind9utils bind9-doc",
      "sudo cp /tmp/bind9 /etc/default/bind9",
      "sudo cp /tmp/named.conf.options /etc/bind/named.conf.options",
      "sudo DEBIAN_FRONTEND=noninteractive systemctl restart bind9",
      "sudo cp /tmp/resolv.conf /etc/resolv.conf",
      "echo 'Done.'"
    ]
  }
# To be fixed
#      "printf \"\nsearch ${var.dns-suffix}\" | sudo tee -a /etc/resolv.conf",
}

resource "null_resource" "first-vm-provisioner" {
  count = var.vm-count

  triggers = {
    bastion-provisioner = null_resource.bastion-provisioner.id,
    first-vm   = azurerm_virtual_machine.dns-demo-vm.*.id[count.index],
    bastion-vm = azurerm_virtual_machine.dns-demo-bastion.id
  }

  connection {
    host         = azurerm_network_interface.dns-demo-nic.*.private_ip_address[count.index]
    bastion_host = azurerm_public_ip.dns-demo-pip.ip_address
    type         = "ssh"
    user         = "superuser"
    private_key  = var.private-key
  }

  provisioner "file" {
    content      = var.private-key
    destination = "/home/superuser/.ssh/azure_pk"
  }

  provisioner "file" {
    content      = var.private-key-pub
    destination = "/home/superuser/.ssh/azure_pk.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "touch ~/test.txt",
      "chmod 0600 ~/.ssh/azure_pk",
      "echo 'Done.'"
    ]
  }
# To be fixed
#      "printf \"\nsearch ${var.dns-suffix}\" | sudo tee -a /etc/resolv.conf",
}
