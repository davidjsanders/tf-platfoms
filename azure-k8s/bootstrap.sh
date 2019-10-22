#!/usr/bin/env bash
echo
echo "Bootstrapping kubernetes cluster: ${notification_text}"
echo "If this configuration is not correct (or desired because"
echo "of minimum requirements) you have 10 seconds to press"
echo "^c (control c)."
bold=`tput bold`
normal=`tput sgr0`
echo ""
echo "Sleeping $${bold}10 seconds$${normal} to allow control-c to cancel"
echo
sleep 10
echo "proceeding"
echo

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
echo "Download and execute Ansible playbook"
echo
git clone https://github.com/dgsd-consulting/ansible-playbooks.git
cd ansible-playbooks/k8s-playbook/
ansible-playbook playbook.yml
ret_stat="$?"
if [ "$ret_stat" != "0" ]
then
    exit $ret_stat
fi

echo
echo "Done."
echo
