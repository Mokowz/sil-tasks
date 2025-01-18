terraform {
  required_providers {
    source = "hashicorp/aws"
    version = "~> 5.0"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "test_vpc" {
  tags = {
    Name = "test_vpc"
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id = aws_vpc.test_vpc.id
  availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
}


resource "aws_security_group" "test_sec_group" {
  name = "all-lots-of-ports"
  vpc_id = aws_vpc.test_vpc.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
  }

  ingress {
    from_port = 8002
    to_port   = 8002
    protocol  = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
  }
}

resource "aws_instance" "books_server" {
  ami       = ""
  instance_type = "t2.micro"
}