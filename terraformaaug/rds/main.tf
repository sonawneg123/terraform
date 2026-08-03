resource "aws_vpc" "terrform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
  
}
resource "aws_subnet" "terraform_subnetpb" {
  vpc_id            = aws_vpc.terrform_vpc.id
  cidr_block        = var.subnet_cidr_block1
  availability_zone = var.availability_zone1
  tags = {
    Name = "terraform-subnetpb"
  }
}
resource "aws_subnet" "terraform_subnetpb2" {
  vpc_id            = aws_vpc.terrform_vpc.id
  cidr_block        = var.subnet_cidr_block2
  availability_zone = var.availability_zone2
  tags = {
    Name = "terraform-subnetpb2"
  }
  
}
resource "aws_subnet" "terraform_subnetpr1" {
    vpc_id            = aws_vpc.terrform_vpc.id
    cidr_block        = var.subnet_cidr_block3
    availability_zone = var.availability_zone1
    tags = {
      Name = "terraform-subnetpr1"
    }
  
}
resource "aws_subnet" "terraform_subnetpr2" {
    vpc_id            = aws_vpc.terrform_vpc.id
    cidr_block        = var.subnet_cidr_block4
    availability_zone = var.availability_zone2
    tags = {
      Name = "terraform-subnetpr2"
    }
  
}
resource "aws_route_table" "terraform_route_tablepb" {
  vpc_id = aws_vpc.terrform_vpc.id
  tags = {
    Name = "terraform-route-table"
  }
  
}
resource "aws_route_table" "terraform_route_tablepr" {
  vpc_id = aws_vpc.terrform_vpc.id
  tags = {
    Name = "terraform-route-table"
  }
  
}
resource "aws_route_table_association" "terraform_route_table_associationpb" {
    subnet_id      = aws_subnet.terraform_subnetpb.id
    route_table_id = aws_route_table.terraform_route_tablepb.id
  
}
resource "aws_route_table_association" "terraform_route_table_associationpb2" {
    subnet_id      = aws_subnet.terraform_subnetpb2.id
    route_table_id = aws_route_table.terraform_route_tablepb.id
  
}
resource "aws_route_table_association" "terraform_route_table_associationpr1" {
    subnet_id      = aws_subnet.terraform_subnetpr1.id
    route_table_id = aws_route_table.terraform_route_tablepr.id
  
}
resource "aws_route_table_association" "terraform_route_table_associationpr2" {
    subnet_id      = aws_subnet.terraform_subnetpr2.id
    route_table_id = aws_route_table.terraform_route_tablepr.id
  
}
resource "aws_internet_gateway" "terraform_internet_gateway" {
  vpc_id = aws_vpc.terrform_vpc.id
  tags = {
    Name = "terraform-internet-gateway"
  }
  
}
resource "aws_eip" "terraform_eip" {
  
  tags = {
    Name = "terraform-eip"
  }

  
}
resource "aws_nat_gateway" "terraform_nat_gateway" {
  allocation_id = aws_eip.terraform_eip.id
  subnet_id     = aws_subnet.terraform_subnetpb.id
  tags = {
    Name = "terraform-nat-gateway"
  }
  
}
resource "aws_route" "terraform_route" {
  route_table_id         = aws_route_table.terraform_route_tablepb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.terraform_nat_gateway.id
}
resource "aws_db_subnet_group" "terraform_subnet_group" {

  subnet_ids = [aws_subnet.terraform_subnetpr1.id, aws_subnet.terraform_subnetpr2.id]
  tags = {
    Name = "terraform-subnet-group"
  }
  
}
resource "aws_security_group" "dbsg" {
  name        = "terraform-security-group"
  description = "Security group for Terraform RDS"
  vpc_id      = aws_vpc.terrform_vpc.id

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
}

resource "aws_db_instance" "master" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.terraform_subnet_group.name
  vpc_security_group_ids = [aws_security_group.dbsg.id]
  skip_final_snapshot   = true
}
resource "aws_db_instance" "read_replica" {
  count                = var.create_read_replica ? 1 : 0
  replicate_source_db  = aws_db_instance.master.id
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.terraform_subnet_group.name
  vpc_security_group_ids = [aws_security_group.dbsg.id]
  skip_final_snapshot   = true
}

