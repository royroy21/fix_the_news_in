provider "aws" {
  profile    = "default"
  region     = "eu-west-2"
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "aws_key_pair" "deployer_staging" {
  key_name   = "deployer_key_staging"
  public_key = var.public_key
}

###############################################################################
# Security groups
###############################################################################
resource "aws_security_group" "ssh_staging" {
  name = "ssh_staging"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "http_staging" {
  name = "http_staging"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_security_group" "https_staging" {
  name = "https_staging"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "postgres_staging" {
  name = "postgres_staging"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

###############################################################################
# Django instance
###############################################################################
resource "aws_instance" "django_staging" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer_staging.key_name
  tags                   = {
    Name = "django-fn-staging",
  }
  vpc_security_group_ids = [
    aws_security_group.ssh_staging.id,
    aws_security_group.http_staging.id,
    aws_security_group.https_staging.id,
  ]
}

resource "aws_eip" "django_staging" {
    vpc      = true
    instance = aws_instance.django_staging.id
}

output "django_server_public_ip" {
  value = aws_eip.django_staging.public_ip
}

###############################################################################
# Database instance
###############################################################################
resource "aws_instance" "database_staging" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer_staging.key_name
  tags                   = {
    Name = "database-fn-staging",
  }
  vpc_security_group_ids = [
    aws_security_group.ssh_staging.id,
    aws_security_group.postgres_staging.id,
  ]
}

resource "aws_eip" "database_staging" {
    vpc      = true
    instance = aws_instance.database_staging.id
}

output "database_server_public_ip_staging" {
  value = aws_eip.database_staging.public_ip
}

###############################################################################
# Webapp
###############################################################################
resource "aws_instance" "webapp_staging" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer_staging.key_name
  tags                   = {
    Name = "webapp-fn-staging",
  }
  vpc_security_group_ids = [
    aws_security_group.ssh_staging.id,
    aws_security_group.http_staging.id,
    aws_security_group.https_staging.id,
  ]
}

resource "aws_eip" "webapp_staging" {
    vpc      = true
    instance = aws_instance.webapp_staging.id
}

output "webapp_server_public_ip_staging" {
  value = aws_eip.webapp_staging.public_ip
}

###############################################################################
# DNS
###############################################################################
resource "cloudflare_record" "django_staging" {
  zone_id = var.cloudflare_zone_id
  name    = "api.staging"
  value   = aws_eip.django_staging.public_ip
  type    = "A"
}

resource "cloudflare_record" "database_staging" {
  zone_id = var.cloudflare_zone_id
  name    = "database.staging"
  value   = aws_eip.database_staging.public_ip
  type    = "A"
}

resource "cloudflare_record" "webapp_staging" {
  zone_id = var.cloudflare_zone_id
  name    = "staging"
  value   = aws_eip.webapp_staging.public_ip
  type    = "A"
}
