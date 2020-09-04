variable "environment" {
  description = "Environment"
}

variable "celery_beat_instance_type" {
  description = "Celery beat instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "VPC security group ids"
}
