resource "aws_instance" "django" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = var.django_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = {
    Name = "${var.environment}_fn_django",
  }
}

resource "aws_eip" "django" {
    vpc      = true
    instance = aws_instance.django.id
}

output "django_server_public_ip" {
  value = aws_eip.django.public_ip
}

output "django_server_private_ip" {
  value = aws_instance.django.private_ip
}

resource "cloudflare_record" "django" {
  zone_id = var.cloudflare_zone_id
  name    = var.django_name
  value   = aws_eip.django.public_ip
  type    = "A"
}
