variable "cloudflare_zone_id" {
  description = "Cloudflare zone id"
}

variable "environment" {
  description = "Environment"
}

variable "webapp_name" {
  description = "Webapp name"
}

variable "webapp_instance_type" {
  description = "Webapp instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "VPC security group ids"
}
