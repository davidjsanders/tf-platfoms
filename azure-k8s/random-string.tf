# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      random-string.tf
# Environments:   all
# Purpose:        Module to define random string which is used for all
#                 passwords, so avoids certain characters.
#
# -------------------------------------------------------------------

resource "random_string" "password" {
  length           = 16
  special          = true
  override_special = "!%^[]{}"
}

