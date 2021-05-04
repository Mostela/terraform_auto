provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.name
  }
  key_name = aws_key_pair.my_key.key_name

  security_groups = [
    aws_security_group.serve_scgroup.name
  ]
}

resource "aws_key_pair" "my_key" {
  key_name   = "${var.name}-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "serve_scgroup" {
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sc_group"
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}

output "state_machine" {
  value = aws_instance.server.instance_state
}