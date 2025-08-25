terraform {
  backend "local" {
    path = "terraform-bootstrap.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}
