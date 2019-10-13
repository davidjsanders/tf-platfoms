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
