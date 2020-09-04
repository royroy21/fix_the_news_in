resource "aws_instance" "beat" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = var.celery_beat_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = {
    Name = "${var.environment}_fn_beat",
  }
}

output "beat_server_private_ip" {
  value = aws_instance.beat.private_ip
}
