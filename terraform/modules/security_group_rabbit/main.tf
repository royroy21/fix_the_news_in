resource "aws_security_group" "rabbit" {
  name = "${var.environment}_rabbit"
  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "security_group_rabbit_id" {
  value = aws_security_group.rabbit.id
}
