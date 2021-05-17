provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_${var.lambda_name}_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
  // File need type zip
  filename      = var.zip_url
  // Can change for s3 deploy
  // This bucket must reside in the same AWS region where you are creating the Lambda function.
  //   s3_bucket = var.s3_bucket_name
  function_name = var.lambda_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  runtime = "nodejs14.x"

  environment {
    variables = {
      env = "prod"
    }
  }
}