provider "aws" {
  region = "us-east-2"
}

variable "name" {
  default = "mostela"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  acl    = "private"

  tags = {
    Name        = var.name
    Environment = "Test"
  }
}

variable "key_file" {}
variable "path_file" {}

resource "aws_s3_bucket_object" "file" {
  bucket = aws_s3_bucket.bucket.id
  key = var.key_file
  source = var.path_file
  acl = "public-read"
}

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}