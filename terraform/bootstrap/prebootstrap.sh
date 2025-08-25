#!/usr/bin/env bash
set -e

ENVIRONMENT=$1
AWS_REGION=$2

S3_BUCKET="tf-state-${ENVIRONMENT}-state"
DYNAMO_TABLE="terraform-locks-${ENVIRONMENT}"

# Create S3 bucket if not exists
if ! aws s3 ls "s3://$S3_BUCKET" --region "$AWS_REGION" >/dev/null 2>&1; then
  echo "Creating S3 bucket $S3_BUCKET"
  aws s3 mb "s3://$S3_BUCKET" --region "$AWS_REGION"
fi

# Create DynamoDB table if not exists
if ! aws dynamodb describe-table --table-name "$DYNAMO_TABLE" --region "$AWS_REGION" >/dev/null 2>&1; then
  echo "Creating DynamoDB table $DYNAMO_TABLE"
  aws dynamodb create-table \
    --table-name "$DYNAMO_TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$AWS_REGION"
fi
