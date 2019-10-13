#!/usr/bin/env bash
echo
echo "Set permissions on SSH keys"
echo
chmod 0600 ~/.ssh/config ~/.ssh/azure_pk

echo
echo "Configure hosts file"
echo
cat ~/hosts | sudo tee /etc/hosts

echo
echo "Configure Ansible inventory"
echo
sudo cp ~/inventory /etc/ansible/hosts
sudo chown root:root /etc/ansible/hosts

echo
echo "Update Dynamic DNS for jumpbox"
echo
url_string="https://${jumpbox_user}:${jumpbox_password}"
url_string="$${url_string}@domains.google.com/nic/update?"
url_string="$${url_string}hostname=${jumpbox_domain_name}"
url_string="$${url_string}&myip=${jumpbox_ip_address}"
url_string="$${url_string}&offline=no"
curl -X POST $${url_string}

echo
echo "Update Dynamic DNS for load balancer"
echo
url_string="https://${wild_user}:${wild_password}"
url_string="$${url_string}@domains.google.com/nic/update?"
url_string="$${url_string}hostname=*${wild_domain_name}"
url_string="$${url_string}&myip=${wild_ip_address}"
url_string="$${url_string}&offline=no"
curl -X POST $${url_string}

echo
echo "Done. **NOTE** It may take up to two minutes for Dynamic DNS"
echo "               changes to be applied. Please wait before"
echo "               ssh-ing to the jumpbox or accessing the load-"
echo "               balancer."
echo
