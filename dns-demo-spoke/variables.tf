variable "vm-count" { default = 3 }
variable "dns-suffix" { default = "" }

#
# Service Principal Variables
#
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

#
# General structure Variables
#
variable "location" { default = "eastus" }

#
# NSG Rules
#
variable "nsg-rules" {
  default = [
    {
        name                        = "NSG-ALLOW-22-JUMPBOX"
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "22"
        source_address_prefix       = "Internet"
    }
  ]
}

#
# Tags
#
variable "tags" {
  type = map(string)
  default = {
    tag-description = "!!Not Defined!!"
    tag-billing     = "!!Not Defined!!"
    tag-environment = "!!Not Defined!!"
  }
}

variable "private-key" {}
variable "private-key-pub" {}
