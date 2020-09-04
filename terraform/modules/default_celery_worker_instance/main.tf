resource "aws_instance" "default_celery_worker" {
  ami                    = "ami-0917237b4e71c5759"
  instance_type          = var.default_celery_worker_instance_type
  tags                   = {
    Name = "${var.environment}_fn_default_celery_worker",
  }
}

output "default_celery_worker_server_private_ip" {
  value = aws_instance.default_celery_worker.private_ip
}
