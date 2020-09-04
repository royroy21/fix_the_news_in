resource "aws_security_group" "https" {
  name = "${var.environment}_https"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 443
    to_port         = 443
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

output "security_group_https_id" {
  value = aws_security_group.https.id
}
