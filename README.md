# tf-platfoms
Terraform platform creation scripts

This set of scripts prepares environments using Terraform with a minimum of configuration to enable future configuration (e.g. Ansible, etc.) to be performed. Scripts currently delivered include:

* **azure-k8s**; a set of scripts to deliver a set of master and worker virtual machines and associated resources (NSGs, load balancers, etc.) to provide an environment which is ready to be purposed for Kubernetes. The script provisions the environment, it does not configure it.
