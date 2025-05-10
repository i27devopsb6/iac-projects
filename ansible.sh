#!/bin/bash
# This script installs Ansible on Ubuntu 22.04
sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible -y
sudo apt install ansible -y



