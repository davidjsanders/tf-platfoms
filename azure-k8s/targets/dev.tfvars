# -------------------------------------------------------------------
#
# Module:         azure-k8s
# Submodule:      dev.tfvars
# Purpose:        Sets of values for the variables used in the
#                 terraform scripts designed for use in development.
#
# -------------------------------------------------------------------

#
# Prod or staging?
#
prod_staging_flag = "prod"

#
# Environment flag; if set to dev, will append a random integer
# to each resource name; if set to blue, will append 'blue' to
# each resource name; if set to green, will apeend 'green' to each
# each resource name; if set to prod, will not append to the
# resource name.
#
environment_flag = "dev"

#
# New VM variables
#

#
# VM
#
vm-jumpbox-name = "k8s-jumpbox"
vm-master-name = "k8s-master"
master-vm-size = "Standard_DS2_v2"
worker-vm-size = "Standard_DS3_v2"
jumpbox-vm-size = "Standard_DS1_v2"
image-name = "img-ubuntu"
image-version = "1-0-26-u"
image-rg = "RG-ENGINEERING"
delete-osdisk-on-termination = true
delete-datadisk-on-termination = false
vm-disable-password-auth = true
vm-osdisk-type = "Premium_LRS"

# vm-count for workers needs to be a minimum of 2
# and is enforced in the tf locals script (locals.tf)
workers = {
    vm-count    = 2
    prefix      = "k8s-worker"
    vm-size     = "Standard_DS3_v2"
    image-id    = "K8S-UBUNTU-1804-19-10-4"
    image-rg    = "RG-ENGINEERING"
    delete_os   = true
    delete_data = true
}

masters = {
    vm-count    = 1
    prefix      = "k8s-master"
    vm-size     = "Standard_DS2_v2"
    image-id    = "K8S-UBUNTU-1804-19-10-4"
    image-rg    = "RG-ENGINEERING"
    delete_os   = true
    delete_data = false
}

# vm-count for jumpboxes needs to be a minimum of 1
# and is enforced in the tf locals script (locals.tf)
jumpboxes = {
    vm-count    = 0
    prefix      = "k8s-jumpbox"
    vm-size     = "Standard_DS1_v2"
    image-id    = "K8S-UBUNTU-1804-19-10-4"
    image-rg    = "RG-ENGINEERING"
    delete_os   = true
    delete_data = true
}

#
# Kubernetes Variables
#
os_k8s_version="1.14.3-00"
kubeadm_api = "kubeadm.k8s.io"
kubeadm_api_version = "v1beta1"
kubeadm_cert_dir = "/etc/kubernetes/pki"
kubeadm_cluster_name = "kubernetes"
kubeadm_pod_subnet = "192.168.0.0/16"
kubeadm_service_subnet = "10.96.0.0/12"
kubeadm_k8s_version = "v1.14.3"

#
# Resource Groups
#
resource-group-name = "K8S"

#
# Storage Account Variables
#
sa-name = "k8s"
sa-persistent-name = "bootdiag"

#
# Location and Tags
#
location = "eastus"
target = "DJS"
environ = "EUS"
tags = {
    tag-description = "K8S Bare metal"
    tag-billing     = "DJS MSDN Subscription"
    tag-environment = "DEV"
    tag-target      = "East US"
    tag-bg          = "dev"
}

#
# Networks
#
vnet-name = "K8S"
vnet-cidr = "10.70.0.0/20"
subnet-master-name = "MGT"
subnet-worker-name = "WRK"
subnet-jump-name = "JUMP"
nsg-name = "K8S"

#
# Load Balancer
#
lb-ports = [
    {
        name = "http-port80"
        protocol = "Tcp"
        frontend-port = "80"
        backend-port = "30888"
    },
    {
        name = "https-port443"
        protocol = "Tcp"
        frontend-port = "443"
        backend-port = "30443"
    }
]
lb-name = "k8slfd"

#
# Network Security Group Rules
#
nsg-rules-jumpbox = [
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
nsg-rules-workers = [
    {
        name                        = "NSG-ALLOW-80-WORKERS"
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "30888"
        source_address_prefix       = "Internet"
    },
    {
        name                        = "NSG-ALLOW-443-WORKERS"
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "30443"
        source_address_prefix       = "Internet"
    }
]


#
# Helm
#
helm_service_account_name = "tiller"
