resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  tags = {

    Name = "Terraform-VPC"

  }

}
resource "aws_subnet" "public1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet1_cidr

  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = {

    Name = "Public-Subnet-1"

  }

}
resource "aws_subnet" "public2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet2_cidr

  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true

  tags = {

    Name = "Public-Subnet-2"

  }

}
resource "aws_subnet" "private1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet1_cidr

  availability_zone = "us-east-1a"

  tags = {

    Name = "Private-Subnet-1"

  }

}
resource "aws_subnet" "private2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet2_cidr

  availability_zone = "us-east-1b"

  tags = {

    Name = "Private-Subnet-2"

  }
}
resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = {

    Name = "Terraform-IGW10"

  }

}
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id

  }
  tags = {
    name = "Public-RT"
  }

}
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_eip" "nat" {
  domain = "vpc"


  tags = {
    Name        = "nat-eip"
    Environment = "dev"
    Project     = "vpc-demo"
  }
}

resource "aws_nat_gateway" "main" {

  allocation_id = aws_eip.nat.id

  subnet_id  = aws_subnet.public1.id
  depends_on = [aws_internet_gateway.main]

  tags = {

    Name = "Terraform-NAT-Gateway"

  }

}
resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "Private-RT"
  }
}
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}
resource "aws_security_group" "main" {

  name        = "terraform-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
