variable "environment" {
  description = "Environment"
}

variable "scoring_worker_instance_type" {
  description = "Scoring worker instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name"
}

variable "vpc_security_group_ids" {
  type        = list(number)
  description = "VPC security group ids"
}
