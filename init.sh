#!/bin/bash
#
# liupeng
# 20180810
# 备份yum源，以防干扰
mkdir /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak

#
cp ./roles/repos/templates/yum.repos.d/ansible.repo.j2 /etc/yum.repos.d/ansible.repo
tar zxvf  ./roles/repos/files/ansible.tar.gz -C /media/ 

yum clean all && yum install ansible -y

# uncomment this to disable SSH key host checking
sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg