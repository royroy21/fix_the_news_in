provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.environment}_deployer_key"
  public_key = var.public_key
}

module "security_group_ssh" {
  environment = var.environment
  source      = "../modules/security_group_ssh"
}

module "security_group_http" {
  environment = var.environment
  source      = "../modules/security_group_http"
}

module "security_group_https" {
  environment = var.environment
  source      = "../modules/security_group_https"
}

module "security_group_postgres" {
  environment = var.environment
  source      = "../modules/security_group_postgres"
}

module "security_group_rabbit" {
  environment = var.environment
  source      = "../modules/security_group_rabbit"
}

module "security_group_rabbit_management" {
  environment = var.environment
  source      = "../modules/security_group_rabbit_management"
}

module "django_instance" {
  django_name          = var.django_name
  cloudflare_zone_id   = var.cloudflare_zone_id
  environment          = var.environment
  django_instance_type = var.instance_type_small
  key_name             = aws_key_pair.deployer.key_name
  source               = "../modules/django_instance"
  vpc_security_group_ids = [
    module.security_group_http.security_group_http_id,
    module.security_group_https.security_group_https_id,
    module.security_group_rabbit.security_group_rabbit_id,
    module.security_group_ssh.security_group_ssh_id,
  ]
}

output "django_server_public_ip" {
  value = module.django_instance.django_server_public_ip
}

output "django_server_private_ip" {
  value = module.django_instance.django_server_private_ip
}

module "database_instance" {
  environment            = var.environment
  database_instance_type = var.instance_type_small
  key_name               = aws_key_pair.deployer.key_name
  source                 = "../modules/database_instance"
  vpc_security_group_ids = [
    module.security_group_postgres.security_group_postgres_id,
    module.security_group_ssh.security_group_ssh_id,
  ]
}

output "database_server_private_ip" {
  value = module.database_instance.database_server_private_ip
}

module "webapp_instance" {
  environment          = var.environment
  cloudflare_zone_id   = var.cloudflare_zone_id
  webapp_instance_type = var.instance_type_small
  key_name             = aws_key_pair.deployer.key_name
  source               = "../modules/webapp_instance"
  webapp_name          = var.webapp_name
  vpc_security_group_ids = [
    module.security_group_http.security_group_http_id,
    module.security_group_https.security_group_https_id,
    module.security_group_ssh.security_group_ssh_id,
  ]
}

output "webapp_server_public_ip" {
  value = module.webapp_instance.webapp_server_public_ip
}

module "s3_instance" {
  environment        = var.environment
  cloudflare_zone_id = var.cloudflare_zone_id
  django_name        = var.django_name
  domain_name        = var.domain_name
  source             = "../modules/s3_instance"
  webapp_name        = var.webapp_name
}
