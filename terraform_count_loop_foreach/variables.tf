variable "ami" {
    description = "The AMI to use for the instance"
    default     = "ami-0947d2ba812810751"
  
}
variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    default     = "10.0.0.0/16"
  
}
variable "vpc_name" {

description = "The name of the VPC"
    default     = "my-vpc"
  
}
variable "az1" {
    description = "The region to create resources"
    default     = "us-east-1a"
}
variable "az2" {
 description = "The region to create resources"
    default     = "us-east-1b"
  
}
variable "subnet1_cidr" {
    description = "The CIDR block for the public subnet 1"
    default     = "10.0.0.0/24"
  
}
variable "subnet2_cidr" {
    description = "The CIDR block for the public subnet 2"
    default     = "10.0.1.0/24"
  
}
variable "subnet3_cidr" {
    description = "The CIDR block for the private subnet 1"
    default     = "10.0.2.0/24"
  
}
variable "subnet4_cidr" {
    description = "The CIDR block for the private subnet 2"
    default     = "10.0.3.0/24"
  
}

variable "subnet1_name" {
    description = "The name of the public subnet 1"
    default     = "public-subnet-1"
  
}
variable "subnet2_name" {
    description = "The name of the public subnet 2"
    default     = "public-subnet-2"
  
}
variable "subnet3_name" {
    description = "The name of the private subnet 1"
    default     = "private-subnet-1"
  
}
variable "subnet4_name" {
    description = "The name of the private subnet 2"
    default     = "private-subnet-2"
  
}

variable "igw_name" {
    description = "The name of the internet gateway"
    default     = "my-igw"
  
}
variable "pubrt_name"{

    
    description = "The name of the public route table"
    default     = "my-pubrt"
  
}
variable"instancecount"{

    
    description = "number of instances to be created"
    default     = "3"


}
variable "instancetype" {
  description = "The instance type to use for the instance"
  default     = "t2.micro"
}
variable "ec2name" {
    description = "The name of the EC2 instance"
    default     = "my-ec2"

}
variable"sgname"{

    
    description = "The name of the security group"
    default     = "my-sg"

}
variable "sgdesc" {
    
    description = "The description of the security group"
    default     = "My security group"
    
  
}