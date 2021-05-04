provider "aws" {
  region = "us-east-1"
}

variable "name" {
  default = "mostela-db"
}

variable "user" {
  default = "mostela"
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "storage" {
  default = 10
  type = number
}

variable "public" {
  default = false
  type = bool
}
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
    cidr_blocks      = ["${chomp(data.http.my_ip.body)}/32"]
  }

  tags = {
    Name = "database-sc_group"
  }

  name = "${var.name}-scg"
}

resource "aws_db_instance" "database" {
  instance_class = var.instance_class
  username = var.user
  allocated_storage    = var.storage
  engine               = "mysql"
  engine_version       = "5.7"
  name                 = "mydb"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = false
  publicly_accessible = var.public

  security_group_names = [
    aws_security_group.database_scgroup.name
  ]

  tags = {
    Name = "DB identifier"
    Key  = var.name
  }
}

output "password_database" {
  value = aws_db_instance.database.password
  sensitive = true
}

output "address" {
  value = aws_db_instance.database.address
}