provider "aws" {
  profile    = "default"
  region     = "eu-west-2"
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.environment}_deployer_key"
  public_key = var.public_key
}

###############################################################################
# Security groups
###############################################################################
resource "aws_security_group" "ssh" {
  name = "${var.environment}_ssh"
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

resource "aws_security_group" "http" {
  name = "${var.environment}_http"
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

resource "aws_security_group" "https" {
  name = "${var.environment}_https"
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

resource "aws_security_group" "postgres" {
  name = "${var.environment}_postgres"
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
resource "aws_instance" "django" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  tags                   = {
    Name = "${var.environment}_fn_django",
  }
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.http.id,
    aws_security_group.https.id,
  ]
}

resource "aws_eip" "django" {
    vpc      = true
    instance = aws_instance.django.id
}

output "django_server_public_ip" {
  value = aws_eip.django.public_ip
}

###############################################################################
# Database instance
###############################################################################
resource "aws_instance" "database" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  tags                   = {
    Name = "${var.environment}_fn_database",
  }
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.postgres.id,
  ]
}

resource "aws_eip" "database" {
    vpc      = true
    instance = aws_instance.database.id
}

output "database_server_public_ip" {
  value = aws_eip.database.public_ip
}

###############################################################################
# Webapp
###############################################################################
resource "aws_instance" "webapp" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  tags                   = {
    Name = "${var.environment}_fn_webapp",
  }
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.http.id,
    aws_security_group.https.id,
  ]
}

resource "aws_eip" "webapp" {
    vpc      = true
    instance = aws_instance.webapp.id
}

output "webapp_server_public_ip" {
  value = aws_eip.webapp.public_ip
}

###############################################################################
# DNS
###############################################################################
resource "cloudflare_record" "django" {
  zone_id = var.cloudflare_zone_id
  name    = var.database_name
  value   = aws_eip.django.public_ip
  type    = "A"
}

resource "cloudflare_record" "database" {
  zone_id = var.cloudflare_zone_id
  name    = var.database_name
  value   = aws_eip.database.public_ip
  type    = "A"
}

resource "cloudflare_record" "webapp" {
  zone_id = var.cloudflare_zone_id
  name    = var.webapp_name
  value   = aws_eip.webapp.public_ip
  type    = "A"
}
