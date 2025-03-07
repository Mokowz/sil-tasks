# Configure the AWS provider
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
    
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "test_vpc"
  }
}

# Create a subnet
resource "aws_subnet" "test_subnet" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create an internet gateway
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
}


# Create a route table
resource "aws_route_table" "test_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"  # Allow traffic to go anywhere
    gateway_id = aws_internet_gateway.test_igw.id
  }
}

# Attach it to the subnet
resource "aws_route_table_association" "attach_rt" {
  subnet_id = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_rt.id
}

# Configure security group to allow access from port 80 (http), 443 (https), and 8000
resource "aws_security_group" "test_sec_group" {
  name = "all-lots-of-ports"
  vpc_id = aws_vpc.test_vpc.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a private key
resource "tls_private_key" "sil_private_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Pair the key
resource "aws_key_pair" "test_key" {
  key_name = "test-key"
  public_key = tls_private_key.sil_private_key.public_key_openssh

  # Store it locally
  provisioner "local-exec" {
    command = "echo '${tls_private_key.sil_private_key.private_key_pem}' > ~/Desktop/Deep-Devops/.keys/test_pkey.pem"
  }
}

resource "aws_instance" "books_server" {
  ami       = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.test_sec_group.id]
  key_name = aws_key_pair.test_key.key_name
  subnet_id = aws_subnet.test_subnet.id

  tags = {
    Name = "Books Server"
  }
}

# Create an Elastic IP and attach it to the instance
resource "aws_eip" "test_eip" {

}

resource "aws_eip_association" "eip_assoc" {
  instance_id = aws_instance.books_server.id
  allocation_id = aws_eip.test_eip.id
}