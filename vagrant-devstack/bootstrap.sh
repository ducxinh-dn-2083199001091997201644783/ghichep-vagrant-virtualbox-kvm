#!/usr/bin/env bash

# Install base tools / applications
sudo apt-get update && sudo apt-get install git wget python-pip python-dev -y

# Download Kilo Stable DevStack
git clone https://github.com/openstack-dev/devstack.git
cd devstack

wget https://raw.githubusercontent.com/hocchudong/ghichep-vagrant-virtualbox-kvm/master/Vagrantfile/vagrant-local.conf.txt
mv vagrant-local.conf.txt local.conf

# Do the stacking
./stack.sh