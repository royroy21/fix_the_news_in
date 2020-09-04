variable "environment" {
  description = "Environment"
}

variable "celery_beat_instance_type" {
  description = "Celery beat instance type"
  default     = "t2.micro"
}
