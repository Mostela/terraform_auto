provider "aws" {
  region = "us-east-1"
}
resource "aws_iam_user" "user" {
  name = var.name
  path = "/users/"
}

resource "aws_iam_group" "developers" {
  name = var.name_group
  path = "/users/"
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

output "id_key" {
  value = aws_iam_access_key.key.id
  sensitive = true
}

output "secret_key" {
  value = aws_iam_access_key.key.secret
  sensitive = true
}