#!/bin/bash
component=$1
environment=$2
#environment=$2
dnf install ansible -y
#ansible-pull -U https://github.com/BharathiP123/-ansible-roboshop-roles-tf.git -e component=$component main.yaml
Repo_url=https://github.com/BharathiP123/-ansible-roboshop-roles-tf.git
Ansible_dir=/opt/robosho/ansible
ansible-project=-ansible-roboshop-roles-tf
ansible_logs=/var/log/roboshop
mkdir -p $Ansible_dir
mkdir -p $ansible_logs
touch ansible.log
##if ansible_dir exist then pull the code
if [-d $Ansible_dir]; then
    cd $Ansible_dir
    git pull 
else
    git clone $Repo_url
    cd $Ansible_dir
fi

##anisnle playbook run
ansible-playbook -e componet=$1   main.yaml 