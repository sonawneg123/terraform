variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
  
}
variable "subnet_cidr_blockpb" {
    description = "CIDR block for the public subnet"
    type        = string
    default     = "10.0.0.0/24"
}
variable "availability_zone1" {
    description = "Availability zone for the public subnet"
    type        = string
    default     = "us-east-1a"
  
}
variable"subnet_cidr_block1" {
    description = "CIDR block for the public subnet"
    type        = string
    default     = "10.0.0.0/24"
}
variable "subnet_cidr_block2" { 
    description = "CIDR block for the private subnet"
    type        = string
    default     = "10.0.1.0/24"
}

  

variable "subnet_cidr_block3" {
    description = "CIDR block for the private subnet"
    type        = string
    default     = "10.0.2.0/24"
}
variable "subnet_cidr_block4" {
    description = "CIDR block for the private subnet"
    type        = string
    default     = "10.0.3.0/24"
  
}

variable "db_name" {
    description = "Name of the database"
    type        = string
    default     = "mydb"
  
}
variable "db_username" {
    description = "Username for the database"
    type        = string
    default     = "admin"
  
}
variable "db_password" {
    description = "Password for the database"
    type        = string
    default     = "password123"
  
}
variable "create_read_replica" {
    description = "Whether to create a read replica"
    type        = bool
    default     = false
  
}
variable "availability_zone2" {
    description = "Availability zone for the first subnet"
    type        = string
    default     = "us-east-1b"
  
}