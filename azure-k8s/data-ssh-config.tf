# Compute and interpolate the variables required for the hosts file
data "template_file" "template-ssh-config" {
  template = file("template-data/config")

  vars = {
    hosts = join(
      " ",
      concat(
        ["k8s-master"],
        [
          for i in range(0, local.l_jumpboxes_vm_count) : 
          format(
            "%s-%01d",
            var.jumpboxes.prefix,
            i+1
          )
        ],
        [
          for i in range(0, local.l_workers_vm_count) : 
            format(
              "%s-%01d",
              var.workers.prefix,
              i+1
            )
        ]
      )
    )
  }
}

