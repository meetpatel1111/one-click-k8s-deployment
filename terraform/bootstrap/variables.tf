# Variables
variable "environment" {
  description = "Deployment environment (dev/test)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for bootstrap resources"
  type        = string
  default     = "us-east-1"
}
