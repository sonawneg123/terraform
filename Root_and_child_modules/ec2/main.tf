resource "aws_instance" "ec1" {
    ami           = var.ami_id
    instance_type = var.instance_type
    tags = {
      Name = "EC2-TF"
    }

  
}