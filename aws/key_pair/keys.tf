provider "aws" {}

variable "name" {
  default = "machine"
}

resource "aws_key_pair" "my_key" {
  key_name   = "${var.name}-key"
  public_key = file("~/.ssh/id_rsa.pub")
}