variable "environment" {
  description = "Environment"
}

variable "default_celery_worker_instance_type" {
  description = "Default celery worker instance type"
  default     = "t2.micro"
}
