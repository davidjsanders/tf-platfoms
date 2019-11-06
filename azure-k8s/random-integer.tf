# -------------------------------------------------------------------
#
# Module:         tf-platforms/azure-k8s-ansible
# Submodule:      random-integer.tf
# Environments:   all
# Purpose:        Module to define a random integer which is used to
#                 ensure unique names.
#
# -------------------------------------------------------------------

resource "random_integer" "unique-sa-id" {
  min = 1000
  max = 9999
}

