data "template_file" "resolv-conf" {
  template = file("templates/etc-resolv-conf")

  vars = {
      dns_suffix = var.dns-suffix
  }
}
