variable "ami" {
    description = "The AMI to use for the instance"
    
  
}
variable "instance_type" {
    description = "The instance type to use for the instance"
    default = "t2.micro"
  
}

variable "key_name" {
    description = "The key pair to use for the instance"
  
}

