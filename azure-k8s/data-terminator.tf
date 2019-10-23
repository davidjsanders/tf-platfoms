# Compute and interpolate the variables required for the hosts file
data "template_file" "template-terminator" {
  template = file("terminator.sh")

  vars = {
    workers = join(
      "\n",
      [
        for i in range(0, var.workers.vm-count) : 
          format(
            "%s-%s",
            var.workers.prefix,
            i+1
          )
      ]
    )
  }
}

