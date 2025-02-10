variable "region" {
  description = "The region in which the VPC will be created."
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store the Terraform state file."
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to store the Terraform state lock."
}

