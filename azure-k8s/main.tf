# -------------------------------------------------------------------
#
# Module:         k8s-terraform/azure-k8s-ansible
# Submodule:      main.tf
# Environments:   all
# Purpose:        Terraform main.tf module.
#
# -------------------------------------------------------------------

provider "azurerm" {
  version         = "1.34.0"
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

provider "random" {
  version = "2.2.0"
}

provider "template" {
  version = "2.1.2"
}

provider "null" {
  version = "2.1.2"
}

