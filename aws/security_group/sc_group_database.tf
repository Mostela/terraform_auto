provider "aws" {}

variable "port_database" {
  type = number
}

data "http" "my_ip" {
  url = "http://checkip.amazonaws.com/"
}

resource "aws_security_group" "database_scgroup" {
  ingress {
    from_port        = var.port_database
    to_port          = var.port_database
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.my_ip.body)}/32"]
  }

  egress {
    from_port        = var.port_database
    to_port          = var.port_database
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sc_group"
  }
}