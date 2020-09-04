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

module "django_module" {
  django_name        = var.django_name
  cloudflare_zone_id = var.cloudflare_zone_id
  environment        = var.environment
  key_name           = aws_key_pair.deployer.key_name
  source             = "../modules/django_instance"
  vpc_security_group_ids = [
    module.security_group_http.security_group_http_id,
    module.security_group_https.security_group_https_id,
    module.security_group_rabbit.security_group_rabbit_id,
    module.security_group_ssh.security_group_ssh_id,
  ]
}

module "database_instance" {
  environment = var.environment
  key_name    = aws_key_pair.deployer.key_name
  source      = "../modules/database_instance"
  vpc_security_group_ids = [
    module.security_group_postgres.security_group_postgres_id,
    module.security_group_ssh.security_group_ssh_id,
  ]
}

module "webapp_instance" {
  environment        = var.environment
  cloudflare_zone_id = var.cloudflare_zone_id
  key_name           = aws_key_pair.deployer.key_name
  source             = "../modules/webapp_instance"
  webapp_name        = var.webapp_name
  vpc_security_group_ids = [
    module.security_group_http.security_group_http_id,
    module.security_group_https.security_group_https_id,
    module.security_group_ssh.security_group_ssh_id,
  ]
}

module "rabbit_instance" {
  environment = var.environment
  key_name    = aws_key_pair.deployer.key_name
  source      = "../modules/rabbit_instance"
  vpc_security_group_ids = [
    module.security_group_rabbit.security_group_rabbit_id,
    module.security_group_rabbit_management.security_group_rabbit_management_id,
    module.security_group_ssh.security_group_ssh_id,
  ]
}

module "default_celery_worker_instance" {
  environment = var.environment
  key_name    = aws_key_pair.deployer.key_name
  source      = "../modules/default_celery_worker_instance"
  vpc_security_group_ids = [
    module.security_group_rabbit.security_group_rabbit_id,
    module.security_group_ssh.security_group_ssh_id,
  ]
}

module "scoring_worker_instance" {
  environment = var.environment
  key_name    = aws_key_pair.deployer.key_name
  source      = "../modules/scoring_worker_instance"
  vpc_security_group_ids = [
    module.security_group_rabbit.security_group_rabbit_id,
    module.security_group_ssh.security_group_ssh_id,
  ]
}

module "celery_beat_instance" {
  environment = var.environment
  key_name    = aws_key_pair.deployer.key_name
  source      = "../modules/celery_beat_instance"
  vpc_security_group_ids = [
    module.security_group_rabbit.security_group_rabbit_id,
    module.security_group_ssh.security_group_ssh_id,
  ]
}

module "s3_instance" {
  environment        = var.environment
  cloudflare_zone_id = var.cloudflare_zone_id
  django_name        = var.django_name
  domain_name        = var.domain_name
  source             = "../modules/s3_instance"
  webapp_name        = var.webapp_name
}
