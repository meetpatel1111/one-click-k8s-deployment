terraform {
  backend "local" {
    path = "terraform-bootstrap.tfstate"
  }
}

# Provider
provider "aws" {
  region = var.aws_region
}

# Check if S3 bucket exists
data "aws_s3_bucket" "existing" {
  bucket = "tfstate-${var.environment}-state"

  # Suppress errors if bucket doesn't exist
  # Terraform <1.7 doesn't support 'ignore_errors', so we handle via count below
}

# Create S3 bucket only if it doesn't exist
resource "aws_s3_bucket" "tfstate" {
  count  = try(length(data.aws_s3_bucket.existing.id), 0) == 0 ? 1 : 0
  bucket = "tfstate-${var.environment}-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Check if DynamoDB table exists
data "aws_dynamodb_table" "existing" {
  name = "terraform-locks-${var.environment}"
}

# Create DynamoDB table only if it doesn't exist
resource "aws_dynamodb_table" "tf_locks" {
  count        = try(length(data.aws_dynamodb_table.existing.name), 0) == 0 ? 1 : 0
  name         = "terraform-locks-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
