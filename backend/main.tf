// Provider block
provider "aws" {
  region = var.region
}


// Resource block
// Create S3 bucket
// "terraform_state" is the name of the resource "aws_s3_bucket". Whenever we have to call this s3_bucket resource, 
// we can reference the resource by using the resource name "terraform_state"
resource "aws_s3_bucket" "terraform_state" {
  // This is the name of the S3 bucket
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = false
  }
}


// Creating s3 bucket versioning
// This block is used to enable versioning on the S3 bucket
// The versioning_configuration block is used to enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket
  versioning_configuration {
    status = "Enabled"
  }
}


// This block is used to enable server-side encryption on the S3 bucket
// The sse_algorithm is set to "AES256" which is the default encryption algorithm
// The apply_server_side_encryption_by_default block is used to enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


// Create a DynamoDB 
// This block is used to create a DynamoDB table
// The name of the DynamoDB table is "terraform_locks"
// The hash_key is "LockID" and the type is "S" which means string
// The billing_mode is "PAY_PER_REQUEST"
// The attribute block is used to define the attribute of the DynamoDB table

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
