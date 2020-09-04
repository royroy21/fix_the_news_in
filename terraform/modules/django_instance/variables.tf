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
