provider "aws" {
  region = "ap-south-1" # Mumbai region
}

# Variables
variable "instance_count" {
  description = "Number of instances to create"
  default     = 2
}

variable "instance_type" {
  description = "Type of instance to launch"
  default     = "t2.micro"
}

variable "instance_name_prefix" {
  description = "Prefix for the instance names"
  default     = "example-"
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
}

variable "key_name" {
  description = "AWS Key Pair name to associate with instances"
}

# Security Group to Allow HTTP, HTTPS, and RDP
resource "aws_security_group" "example_sg" {
  name        = "example-security-group"
  description = "Allow HTTP, HTTPS, and RDP inbound traffic"
  vpc_id      = var.vpc_id

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
  count               = var.instance_count
  ami                 = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  tags = {
    Name = "${var.instance_name_prefix}${count.index + 1}"
  }
}

# Outputs
output "instance_ids" {
  description = "IDs of EC2 instances"
  value       = aws_instance.example.*.id
}

output "public_ips" {
  description = "Public IPs of EC2 instances"
  value       = aws_instance.example.*.public_ip
}
