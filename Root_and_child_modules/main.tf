provider "aws"{
    region = var.aws_region

}
module "ec2" {
    source = "./ec2"
    instance_type = var.instance_type
    ami_id = var.ami_id



  
}