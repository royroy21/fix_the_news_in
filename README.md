This project describes fixthenews.com architecture. 

This project is loaded onto the devops server which manages builds and provisioning.

## Terraform (v0.12.24)
Terraform is used for creating, changing and destroying infrastructure.

Secrets are stored in terraform.tfvars files for each environment.

terraform.tfvars files are not part of this repo.

## Ansible (2.9.9)
Ansible is used for provisioning machined created by Terraform.

All files in the inventories directory are encrypted. A password.txt file is required to decrypt these files. 

The password.txt file is not part of this repo.
