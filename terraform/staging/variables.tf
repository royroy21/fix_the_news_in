variable "public_key" {
  description = "Public key used for ssh into AWS servers"
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
