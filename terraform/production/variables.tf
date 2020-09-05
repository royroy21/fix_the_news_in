variable "environment" {
  description = "Environment"
}

variable "django_name" {
  description = "django's URL prefix"
}

variable "domain_name" {
  description = "root domain name"
}

variable "cloudflare_email" {
  description = "Email address for access to Cloudflare"
}

variable "cloudflare_api_key" {
  description = "API KEY for access to Cloudflare"
}

variable "cloudflare_zone_id" {
  description = "DNS zone id for Cloudflare"
}

variable "instance_type_mini" {
  description = "instance_type_mini"
  default     = "t2.mini"
}

variable "public_key" {
  description = "Public key used for ssh into AWS servers"
}

variable "webapp_name" {
  description = "webapp's URL prefix"
}
