variable "environment" {
  description = "Environment"
}

variable "database_instance_type" {
  description = "Database instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name"
}

variable "vpc_security_group_ids" {
  type        = list(number)
  description = "VPC security group ids"
}
