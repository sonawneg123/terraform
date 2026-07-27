resource "aws_vpc" "vpctf" {
 cidr_block = var.vpc_cidr

 tags = {
    Name = var.vpc_name
  }

  
}
resource "aws_subnet" "pbsn1" {
    vpc_id = aws_vpc.vpctf.id
    cidr_block = var.subnet1_cidr
    availability_zone = var.az1
    
    tags = {
        Name = var.subnet1_name
    }
  
}
resource "aws_subnet" "pbsn2" {
    vpc_id = aws_vpc.vpctf.id
    cidr_block = var.subnet2_cidr
    availability_zone = var.az2
    
    tags = {
        Name = var.subnet2_name
    }
  
}
resource"aws_subnet""prsn1"{
    vpc_id=aws_vpc.vpctf.id
    cidr_block=var.subnet3_cidr
    availability_zone=var.az2
    
    tags={
        Name=var.subnet3_name

    }

}
resource "aws_internet_gateway" "igwtf" {
    vpc_id = aws_vpc.vpctf.id

    tags = {
        Name = var.igw_name
    }
  
}
resource"aws_route_table""pubrt"{
    vpc_id=aws_vpc.vpctf.id

    route{
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.igwtf.id
    }
    tags={
        Name=var.pubrt_name
    }

}
resource"aws_route_table_association""pubrtassoc1"{
    subnet_id=aws_subnet.pbsn1.id
    route_table_id=aws_route_table.pubrt.id

}
resource "aws_route_table_association" "pbrtassoc2" {
    subnet_id = aws_subnet.pbsn2.id
    route_table_id = aws_route_table.pubrt.id
  
}
resource "aws_instance" "ec2name" {
    # count = var.instancecount
    for_each = {
        frontend = "t3.micro"
        backend = "t3.small"
        database = "c7i-flex.large"
        

    }
    
    depends_on = [aws_subnet.pbsn1]
    availability_zone = var.az1

    ami = var.ami
    instance_type = each.value
    subnet_id = aws_subnet.pbsn1.id
    tags = {
        Name = each.key
    }
  
}
resource "aws_security_group" "sg" {
    name = each.key
    description = var.sgdesc
    vpc_id = aws_vpc.vpctf.id
    for_each = {
      "ssh" =  "22"
      "mysql" = "3306"
      "webserver" = "80"
      "https" ="443"
    }

    ingress {
        from_port = each.value
        to_port = each.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
   
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags= {
        Name = "Gaurav"
    }
          
    
  
}