resource "aws_instance" "rabbit" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = var.rabbit_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = {
    Name = "${var.environment}_fn_rabbit",
  }
}

output "rabbit_server_private_ip" {
  value = aws_instance.rabbit.private_ip
}
