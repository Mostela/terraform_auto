variable "lambda_name" {
  type = string
}

variable "zip_url" {
  type = string
  default = "lambda_example.zip"
}

variable "s3_bucket_name" {
  default = ""
  type = string
}