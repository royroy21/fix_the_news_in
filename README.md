This project describes fixthenews.com architecture. 

## Terraform (v0.12.24)
Terraform is used for creating, changing and destroying infrastructure.

Currently this is designed to be run locally.

Secrets are stored in terraform.tfvars files for each environment.

terraform.tfvars files are not part of this repo.

## Ansible (2.9.9)
Ansible is used for provisioning machined created by Terraform.

The devops server is designed to be provisioned locally. 

The devops server is responsible for provisioning staging and production environments. 

The devops server is responsible for creating/renewing and pushing SSL certificates to environments.

All files in the inventories directory are encrypted. A password.txt file is required to decrypt these files. 

The password.txt file is not part of this repo.
