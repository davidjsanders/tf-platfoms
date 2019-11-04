# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      main.tf
# Environments:   all
# Purpose:        Terraform main.tf module.
#
# -------------------------------------------------------------------

resource "null_resource" "deprovisioner" {
  triggers = {
    vm_k8s_master_1_id = azurerm_virtual_machine.vm-master.id
    jumpboxes = "${join(",", azurerm_virtual_machine.vm-jumpbox.*.id)}"
    workers = "${join(",", azurerm_virtual_machine.vm-workers.*.id)}"
  }

  connection {
    host         = azurerm_network_interface.k8s-nic-master.private_ip_address
    bastion_host = azurerm_public_ip.k8s-pip-jump.*.ip_address[0]
    type         = "ssh"
    user         = var.vm-adminuser
    private_key  = var.private-key
  }

  provisioner "file" {
    content     = data.template_file.template-terminator.rendered
    destination = "/home/${var.vm-adminuser}/terminator.sh"
    when        = "destroy"
  }

  provisioner "remote-exec" {
    when        = "destroy"
    inline = [
      "chmod +x ~/terminator.sh",
      "~/terminator.sh",
      "echo 'Done.'",
    ]
  }
}

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
    private_key = var.private-key
  }

  provisioner "file" {
    content      = var.private-key
    destination = "/home/${var.vm-adminuser}/.ssh/azure_pk"
  }

  provisioner "file" {
    content      = var.private-key-pub
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

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/bootstrap.sh",
      "~/bootstrap.sh",
      "echo 'Done.'",
    ]
  }

# TODO
# Reset DDNS when destroying completely - i.e. not when modifying
# workers

}

