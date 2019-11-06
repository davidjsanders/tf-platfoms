# -------------------------------------------------------------------
#
# Module:         tf-platforms/azure-k8s-ansible
# Submodule:      data-managed-disks.tf
# Environments:   all
# Purpose:        Module to get the persistent Azure managed disks.
#
# -------------------------------------------------------------------

# Get the managed disk being used to provide persistent storage
# for the k8s cluster.
data "azurerm_managed_disk" "datasourcemd" {
  name                = var.disk-master-name
  resource_group_name = var.disk-rg-name
}

