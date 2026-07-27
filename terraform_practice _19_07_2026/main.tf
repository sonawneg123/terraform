resource "aws_vpc" "alb" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "alb-vpc"
  }

}
resource "aws_subnet" "pbsn1" {
  vpc_id            = aws_vpc.alb.id
  cidr_block        = var.subnet1_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "pbsn1"
  }

}
resource "aws_subnet" "pbsn2" {
  vpc_id            = aws_vpc.alb.id
  cidr_block        = var.subnet2_cidr
  availability_zone = "us-east-1b"
  tags = {
    Name = "pbsn2"
  }

}


resource "aws_security_group" "albsg" {


  name        = "alb-sg"
  description = "ALB security group"
  vpc_id      = aws_vpc.alb.id

  ingress {
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
    Name = "alb-sg"
  }

}
resource "aws_alb" "alb" {
  name               = "alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.albsg.id]
  subnets            = [aws_subnet.pbsn1.id, aws_subnet.pbsn2.id]

  tags = {
    Name = "alb-tf"
  }
}
resource "aws_lb_target_group" "exttg" {

  name     = "external-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.alb.id

}
resource "aws_lb_listener" "extl" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.exttg.arn
  }

}
resource "aws_lb_target_group_attachment" "tga" {


  target_group_arn = aws_lb_target_group.exttg.arn
  target_id        = aws_instance.web.id
  port             = 80

}
resource "aws_internet_gateway" "igw19" {

  vpc_id = aws_vpc.alb.id
  tags = {
    Name = "igw19"
  }


}
resource "aws_route_table" "rt19" {
  vpc_id = aws_vpc.alb.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw19.id
  }

  tags = {
    Name = "rt19"
  }

}
resource "aws_route_table_association" "rta19" {

  subnet_id      = aws_subnet.pbsn1.id
  route_table_id = aws_route_table.rt19.id



}
resource "aws_route_table_association" "rtaa19" {

  subnet_id      = aws_subnet.pbsn2.id
  route_table_id = aws_route_table.rt19.id



}
resource "aws_instance" "web" {
  ami                         = "ami-01edba92f9036f76e"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.pbsn1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.albsg.id]


  tags = {
    Name = "web-server"
  }

}

resource "aws_iam_user""dev1"{
  
  name = "dev1"

}
resource "aws_iam_access_key""dev1key"{
  
  user = aws_iam_user.dev1.name
  

}
resource "aws_iam_user" "dev2" {
  
  name = "dev2"
  
}

resource "aws_iam_access_key" "dev2key" {
  
  user = aws_iam_user.dev2.name
  

}
resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucketweqdasdd"


  tags = {
    Name = "My bucket"
  }
}
resource "aws_iam_role" "s3role" {
  name = "s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
          
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  
}
resource "aws_iam_role_policy_attachment" "s3policy" {
  role       = aws_iam_role.s3role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
resource "aws_iam_group" "name" {
  
  name = "readonly"
  
}
resource "aws_iam_group_membership" "team" {
  name = "tf-group-membership"

  group = aws_iam_group.name.name
  users = [
    aws_iam_user.dev1.name,
    aws_iam_user.dev2.name,
  ]
}

resource"aws_iam_policy""police"{

  
  name = "policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
        ]
        Resource = "*"
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "role_attach" {

  role = aws_iam_role.s3role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}