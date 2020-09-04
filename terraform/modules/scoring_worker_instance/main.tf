resource "aws_instance" "scoring_worker" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = var.scoring_worker_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = {
    Name = "${var.environment}_fn_scoring_worker",
  }
}

output "scoring_worker_server_private_ip" {
  value = aws_instance.scoring_worker.private_ip
}
