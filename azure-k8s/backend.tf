# -------------------------------------------------------------------
#
# Module:         k8s-terraform
# Submodule:      backend.tf
# Environments:   all
# Purpose:        Define the backend as Azure.
#
# -------------------------------------------------------------------

terraform {
  backend "azurerm" {
  }
}

