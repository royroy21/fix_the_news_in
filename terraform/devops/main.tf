provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "aws_key_pair" "deployer_devops" {
  key_name   = "deployer_key_devops"
  public_key = var.public_key
}

###############################################################################
# Security groups
###############################################################################
resource "aws_security_group" "ssh_devops" {
  name = "ssh_devops"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

###############################################################################
# Devops instance
###############################################################################
resource "aws_instance" "devops" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer_devops.key_name
  tags                   = {
    Name = "devops-fn",
  }
  vpc_security_group_ids = [
    aws_security_group.ssh_devops.id,
  ]
}

resource "aws_eip" "devops" {
    vpc      = true
    instance = aws_instance.devops.id
}

output "devops_server_public_ip" {
  value = aws_eip.devops.public_ip
}

###############################################################################
# DNS
###############################################################################
resource "cloudflare_record" "devops" {
  zone_id = var.cloudflare_zone_id
  name    = "devops"
  value   = aws_eip.devops.public_ip
  type    = "A"
}
