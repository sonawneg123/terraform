provider "aws" {
  region = var.aws_region
}

# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "terravpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "task13july"
  }
}

# -----------------------------
# Subnets
# -----------------------------
resource "aws_subnet" "pbsn1" {
  vpc_id                  = aws_vpc.terravpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pbsn1"
  }
}

resource "aws_subnet" "pbsn2" {
  vpc_id                  = aws_vpc.terravpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "pbsn2"
  }
}

resource "aws_subnet" "prsn1" {
  vpc_id            = aws_vpc.terravpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prsn1"
  }
}

resource "aws_subnet" "prsn2" {
  vpc_id            = aws_vpc.terravpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "prsn2"
  }
}

# -----------------------------
# Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terravpc.id

  tags = {
    Name = "task13july-igw"
  }
}

# -----------------------------
# Public Route Table
# -----------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terravpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "task13july-public-rt"
  }
}

resource "aws_route_table_association" "pbrt1" {
  subnet_id      = aws_subnet.pbsn1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pbrt2" {
  subnet_id      = aws_subnet.pbsn2.id
  route_table_id = aws_route_table.public_rt.id
}

# -----------------------------
# NAT Gateway (lives in a public subnet)
# -----------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "task13july-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pbsn1.id

  tags = {
    Name = "task13july-nat-gw"
  }

  depends_on = [aws_internet_gateway.igw]
}

# -----------------------------
# Private Route Table
# -----------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.terravpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "task13july-private-rt"
  }
}

resource "aws_route_table_association" "prrt1" {
  subnet_id      = aws_subnet.prsn1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "prrt2" {
  subnet_id      = aws_subnet.prsn2.id
  route_table_id = aws_route_table.private_rt.id
}

# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "ec2_sg" {
  name   = "task13july-sg"
  vpc_id = aws_vpc.terravpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "task13july-sg"
  }
}

# -----------------------------
# EC2 Instances
# -----------------------------
resource "aws_instance" "public_instance" {
  ami                         = "ami-01edba92f9036f76e"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.pbsn1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "task13july-public-instance"
  }
  
  provisioner "local-exec" {
    command = "echo Hello Terraform"
  }
}

resource "aws_instance" "private_instance" {
  ami                         = "ami-01edba92f9036f76e"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.prsn1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "task13july-private-instance"
  }
}
#===========================================
##################RDS########################
#===========================================
resource "aws_security_group" "dbsg" {
  vpc_id = aws_vpc.terravpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
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
    Name = "task13july-rds-sg"
  }
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "task13july-db-subnet-group"
  subnet_ids = [aws_subnet.prsn1.id, aws_subnet.prsn2.id]

  tags = {
    Name = "task13july-db-subnet-group"
  }
}
# resource "aws_db_instance" "rds13" {
#   allocated_storage    = 20
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
  
 
#   username             = "admin"
#   password             = "password123"
#   parameter_group_name = "default.mysql8.0"
#   db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.dbsg.id]
#   skip_final_snapshot   = true

#   tags = {
#     Name = "task13july-rds-instance"
#   }
  
# }