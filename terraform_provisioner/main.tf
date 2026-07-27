resource"aws_vpc""myvpc"{
    
    cidr_block="10.0.0.0/16"
    tags={
        Name="myvpc"
    }
    

}
resource "aws_subnet" "pbsn1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "pbsn1"
    }
  
}
resource "aws_subnet" "pbsn2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "pbsn2"
    }
  
}

resource "aws_subnet" "prsn1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "prsn1"
    }
  
}
resource "aws_subnet" "prsn2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "prsn2"
    }
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_eip" "eip" {
    domain = "vpc"
    tags = {
        Name = "eip"
    }
  
}
resource "aws_nat_gateway" "nat22" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.pbsn2.id

    tags = {
        Name = "nat22"
    }
  
}
resource "aws_route_table" "pubrt" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "pubrt"
    }
  
}


resource "aws_route_table" "privrt" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat22.id
    }

    tags = {
        Name = "privrt"
    }
  
}
resource "aws_route_table_association" "pubrtassoc1" {
    subnet_id = aws_subnet.pbsn1.id
    route_table_id = aws_route_table.pubrt.id
}
resource "aws_route_table_association" "pubrtassoc2" {
    subnet_id = aws_subnet.pbsn2.id
    route_table_id = aws_route_table.pubrt.id
}
resource "aws_route_table_association" "privrtassoc1" {
    subnet_id = aws_subnet.prsn1.id
    route_table_id = aws_route_table.privrt.id
}
resource "aws_route_table_association" "privrtassoc2" {
  subnet_id = aws_subnet.prsn2.id
  route_table_id = aws_route_table.privrt.id

}
resource "aws_instance" "server" {
ami= "ami-0b826bb6d96d2afe4"
instance_type = "t3.micro"
subnet_id = aws_subnet.pbsn1.id



  
}
resource "aws_security_group" "web-sg" {
  name = "web-sg"
  description = "Allow port 80 and 443"
  vpc_id = aws_vpc.myvpc.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}   

resource "aws_db_subnet_group" "sbnetgrp" {

  name = "db-subnet-group"

  subnet_ids = [
    aws_subnet.prsn1.id,
    aws_subnet.prsn2.id
  ]

  tags = {
    Name = "DB Subnet Group"
  }
}
resource "aws_db_instance" "mysql" {
    allocated_storage = 20
    db_name = "mydb"
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t3.micro"
    username = "admin"
    password = "password"
    parameter_group_name = "default.mysql5.7"
    db_subnet_group_name = aws_db_subnet_group.sbnetgrp.name
    skip_final_snapshot = true
  
}
resource "null_resource" "import_schema" {

  depends_on = [aws_db_instance.mysql]

  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.mysql.address} -u ${var.db_username} -p${var.db_password} ${var.db_name} < schema.sql"
  }
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "admin"
}
variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "password"
}
variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "mydb"
}

resource "aws_instance" "app_server" {

  ami                    = var.ami
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.pbsn1.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("C:/Users/hp/Downloads/terraform-key.pem")

  }

  provisioner "file" {
    source      = "schema.sql"
    destination = "C:/Users/hp/Downloads/nyaya-sahayak-project"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Schema copied successfully'",
      "ls -l /home/ec2-user/schema.sql"
    ]
  }

  tags = {
    Name = "Provisioner-EC2"
  }
}
