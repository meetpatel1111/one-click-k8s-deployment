variable "environment" {
  description = "Deployment environment (dev/test)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
