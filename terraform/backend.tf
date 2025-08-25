terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-${var.environment}"
    key            = "state/terraform.tfstate"                 
    region         = "us-east-1"                           
    dynamodb_table = "terraform-locks-${var.environment}"      
    encrypt        = true
  }
}
