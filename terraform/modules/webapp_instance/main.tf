resource "aws_instance" "webapp" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = var.webapp_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = {
    Name = "${var.environment}_fn_webapp",
  }
}

resource "aws_eip" "webapp" {
  vpc      = true
  instance = aws_instance.webapp.id
}

output "webapp_server_public_ip" {
  value = aws_eip.webapp.public_ip
}

resource "cloudflare_record" "webapp" {
  zone_id = var.cloudflare_zone_id
  name    = var.webapp_name
  value   = aws_eip.webapp.public_ip
  type    = "A"
}
