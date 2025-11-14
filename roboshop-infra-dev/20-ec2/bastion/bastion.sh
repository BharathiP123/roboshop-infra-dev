#!/bin/bash


# growing the /home volume for terraform purpose
growpart /dev/nvme0n1 4
lvextend -L +30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

# sudo lvreduce -r -L 6G /dev/mapper/RootVG-rootVol

cd /home/ec2-user
git clone https://github.com/BharathiP123/roboshop-infra-dev.git
cd /home/ec2-user/roboshop-infra-dev/roboshop-infra-dev
cd /home/ec2-user/roboshop-infra-dev/roboshop-infra-dev/40-databases
chown ec2-user:ec2-user -R roboshop-infra-dev
terraform init
terraform plan
terraform apply -auto-approve