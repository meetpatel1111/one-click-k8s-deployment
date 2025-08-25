variable "environment" {
  type = string
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-${var.environment}"
    key            = "k8s/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-${var.environment}"
    encrypt        = true
  }
}
