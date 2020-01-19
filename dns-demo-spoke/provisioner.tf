resource "null_resource" "provisioner" {
  count = var.vm-count

  triggers = {
    first-vm   = azurerm_virtual_machine.dns-demo-vm.*.id[count.index],
  }

  connection {
    host         = azurerm_network_interface.dns-demo-nic.*.private_ip_address[count.index]
    bastion_host = data.azurerm_public_ip.dns-demo-pip.ip_address
    type         = "ssh"
    user         = "superuser"
    private_key  = var.private-key
    timeout      = "1m"
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
    content     = data.template_file.resolv-conf.rendered
    destination = "/tmp/resolv.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /tmp/resolv.conf",
      "sudo cp /tmp/resolv.conf /etc/resolv.conf",
      "chmod 0600 ~/.ssh/azure_pk",
      "echo 'Done.'"
    ]
  }
# "printf \"\nsearch ${var.dns-suffix}\" | sudo tee -a /etc/resolv.conf",
# To be fixed
#      "printf \"\nsearch ${var.dns-suffix}\" | sudo tee -a /etc/resolv.conf",
}
