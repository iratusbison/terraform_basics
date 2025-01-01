provider "aws" {
    region = "ap-south-1" # Mumbai region
}

# Variables
variable "instance_count" {
    default = 2
}

variable "instance_type" {
    default = "t2.micro"
}

variable "instance_name_prefix" {
    default = "ex-"
}

# Security Group to Allow HTTP, HTTPS, and RDP
resource "aws_security_group" "example_sg" {
  name        = "example-security-group"
  description = "Allow HTTP, HTTPS, and RDP inbound traffic"
  vpc_id      = "your vpc" # Replace with your VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-security-group"
  }
}

# EC2 Instance
resource "aws_instance" "example" {
   count = var.instance_count
   ami = "your ami here"
   instance_type = var.instance_type

   vpc_security_group_ids = [aws_security_group.example_sg.id]

   tags = {
      Name = "${var.instance_name_prefix}${count.index + 1}"
   }
}

# Output
output "instance_ids" {
    description = "IDs of EC2 instances"
    value = aws_instance.example.*.id
}

output "public_ips" {
    description = "Public IPs of EC2 instances"
    value = aws_instance.example.*.public_ip
}
