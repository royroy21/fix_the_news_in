resource "aws_instance" "rabbit" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = var.rabbit_instance_type
  tags                   = {
    Name = "${var.environment}_fn_rabbit",
  }
}

output "rabbit_server_private_ip" {
  value = aws_instance.rabbit.private_ip
}
