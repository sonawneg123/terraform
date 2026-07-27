resource "aws_vpc" "prod" {


  
}
resource "aws_vpc" "dev" {

    
  
}
resource "aws_instance" "ec2" {
    ami = data.aws_ami.ami.id
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = prod
    


tags = {
        Name = "webserver"
    }

  
}
data "aws_ami" "ami"{
    
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }


}
resource "aws_security_group" "sg" {
    name = "allow_tls"
    description = "Allow tls inbound traffic"
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  
}
data "aws_vpc" "prod"{
    id = aws_vpc.prod.id



}
resource "aws_instance" "" {
  
}
