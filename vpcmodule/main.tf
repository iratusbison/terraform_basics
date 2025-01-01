provider "aws" {
  region = "us-east-1" # North Virginia
}

resource "aws_vpc" "main" {
  cidr_block = "1.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "1.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "1.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "main-nat-gw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public_rt_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route" "private_rt_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_instance" "public_instance" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI for us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "keypar28"

  tags = {
    Name = "public-instance"
  }

  provisioner "local-exec" {
    command = "echo Public instance created"
  }
}

resource "aws_instance" "private_instance" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI for us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = "keypar28"

  associate_public_ip_address = false # Disable public IP

  tags = {
    Name = "private-instance"
  }

  provisioner "local-exec" {
    command = "echo Private instance created"
  }
}
