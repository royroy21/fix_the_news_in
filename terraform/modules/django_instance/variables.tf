variable "cloudflare_zone_id" {
  description = "Cloudflare zone id"
}

variable "django_name" {
  description = "Django name"
}

variable "environment" {
  description = "Environment"
}

variable "django_instance_type" {
  description = "Django instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "VPC security group ids"
}
