resource "aws_instance" "scoring_worker" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = var.scoring_worker_instance
  tags                   = {
    Name = "${var.environment}_fn_scoring_worker",
  }
}

output "scoring_worker_server_private_ip" {
  value = aws_instance.scoring_worker.private_ip
}
