# Compute and interpolate the variables required for the hosts file
data "template_file" "template-terminator" {
  template = file("terminator.sh")

  vars = {
    workers = join(
      "\n",
      [
        for i in range(0, local.l_workers_vm_count) : 
          format(
            "%s-%s",
            var.workers.prefix,
            i+1
          )
      ]
    )
  }
}

