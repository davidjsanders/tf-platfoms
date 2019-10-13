# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      main.tf
# Environments:   all
# Purpose:        Terraform main.tf module.
#
# Created on:     23 June 2019
# Created by:     David Sanders
# Creator email:  dsanderscanada@nospam-gmail.com
#
# -------------------------------------------------------------------
# Modifed On   | Modified By                 | Release Notes
# -------------------------------------------------------------------
# 23 Jun 2019  | David Sanders               | First release.
# -------------------------------------------------------------------

resource "null_resource" "provisioner" {
  triggers = {
    vm_k8s_master_1_id = azurerm_virtual_machine.vm-master.id
    jumpboxes = "${join(",", azurerm_virtual_machine.vm-jumpbox.*.id)}"
    workers = "${join(",", azurerm_virtual_machine.vm-workers.*.id)}"
  }

  connection {
    host        = azurerm_public_ip.k8s-pip-jump.*.ip_address[0]
    type        = "ssh"
    user        = var.vm-adminuser
    private_key = file(local.l_pk_file)
  }

  provisioner "file" {
    source      = var.private-key
    destination = "/home/${var.vm-adminuser}/.ssh/azure_pk"
  }

  provisioner "file" {
    source      = "${var.private-key}.pub"
    destination = "/home/${var.vm-adminuser}/.ssh/azure_pk.pub"
  }

  provisioner "file" {
    content     = data.template_file.template-bootstrap.rendered
    destination = "/home/${var.vm-adminuser}/bootstrap.sh"
  }

  provisioner "file" {
    content     = data.template_file.template-hosts-file.rendered
    destination = "/home/${var.vm-adminuser}/hosts"
  }

  provisioner "file" {
    content     = data.template_file.template-ansible-inventory.rendered
    destination = "/home/${var.vm-adminuser}/inventory"
  }

  provisioner "file" {
    content     = data.template_file.template-ssh-config.rendered
    destination = "/home/${var.vm-adminuser}/.ssh/config"
  }

  # provisioner "local-exec" {
  #   command = format(
  #     "echo 'DDNS: %s --> *.%s'; curl -X POST 'https://%s:%s@domains.google.com/nic/update?hostname=%s&myip=%s&offline=no'; echo",
  #     azurerm_public_ip.k8s-pip-jump.*.ip_address[0],
  #     var.jumpbox_domain_name,
  #     var.jumpbox_username,
  #     var.jumpbox_password,
  #     var.jumpbox_domain_name,
  #     azurerm_public_ip.k8s-pip-jump.*.ip_address[0]
  #   )
  # }

  # provisioner "local-exec" {
  #   command = format(
  #     "echo 'DDNS: %s --> *%s'; curl -X POST 'https://%s:%s@domains.google.com/nic/update?hostname=*%s&myip=%s&offline=no'; echo",
  #     azurerm_public_ip.k8s-pip-lb.ip_address,
  #     var.ddns_domain_name,
  #     var.wild_username,
  #     var.wild_password,
  #     var.ddns_domain_name,
  #     azurerm_public_ip.k8s-pip-lb.ip_address
  #   )
  #   # command = "echo 'DDNS: ${} 
  #   # --> *.${}'; curl -X POST 'https://${}:${}@domains.google.com/nic/update?hostname=*${}&myip=${}&offline=no'; echo"
  # }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/bootstrap.sh",
      "~/bootstrap.sh",
      "echo 'Done.'",
    ]
  }

  # provisioner "local-exec" {
  #   command = format(
  #     "echo 'DDNS: %s --> *.%s'; curl -X POST 'https://%s:%s@domains.google.com/nic/update?hostname=%s&myip=%s&offline=yes'; echo",
  #     azurerm_public_ip.k8s-pip-jump.*.ip_address[0],
  #     var.jumpbox_domain_name,
  #     var.jumpbox_username,
  #     var.jumpbox_password,
  #     var.jumpbox_domain_name,
  #     "0.0.0.0"
  #   )
  #   # command = "echo 'DDNS: ${azurerm_public_ip.k8s-pip-lb.ip_address} /-> *.${var.ddns_domain_name}'; curl -X POST 'https://${var.wild_username}:${var.wild_password}@domains.google.com/nic/update?hostname=*${var.ddns_domain_name}&myip=0.0.0.0&offline=yes'; echo"
  #   when    = destroy
  # }

  # provisioner "local-exec" {
  #   command = format(
  #     "echo 'DDNS: %s --> *%s'; curl -X POST 'https://%s:%s@domains.google.com/nic/update?hostname=*%s&myip=%s&offline=yes'; echo",
  #     azurerm_public_ip.k8s-pip-lb.ip_address,
  #     var.ddns_domain_name,
  #     var.wild_username,
  #     var.wild_password,
  #     var.ddns_domain_name,
  #     "0.0.0.0"
  #   )
  #   # command = "echo 'DDNS: ${azurerm_public_ip.k8s-pip-jump.ip_address} /-> *.${var.jumpbox_domain_name}'; curl -X POST 'https://${var.jumpbox_username}:${var.jumpbox_password}@domains.google.com/nic/update?hostname=${var.jumpbox_domain_name}&myip=0.0.0.0&offline=yes'; echo"
  #   when    = destroy
  # }
}

