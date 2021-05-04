variable "name" {
  default = "server"
}

data "http" "my_ip" {
  url = "http://checkip.amazonaws.com/"
}

resource "aws_security_group" "serve_scgroup" {
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.my_ip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["${data.http.my_ip.body}/0"]
  }

  tags = {
    Name = "${var.name}-sc_group"
  }
}