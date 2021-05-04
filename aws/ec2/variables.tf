variable "name" {
  default = "mostelao"
  type = string
  description = "One name for your machine"
}

variable "instance_type" {
  default = "t2.micro"
  description = "Instance Type in AWS. Payment"
}