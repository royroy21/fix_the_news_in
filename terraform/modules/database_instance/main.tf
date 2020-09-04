resource "aws_instance" "database" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = var.database_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = {
    Name = "${var.environment}_fn_database",
  }
}

output "database_server_private_ip" {
  value = aws_instance.database.private_ip
}
