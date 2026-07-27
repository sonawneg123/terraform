variable "db_name" {
    description = "The name of the db"
    type = string
  
} 
 variable "db_username" {
    description = "The username for db"
    type = string
    
   
 }
 variable "db_password" {
    description = "The password for db"
    type = string
    
   
 }
 variable "allocated_storage" {
    description = "The allocated storage for db"
    type = number
    

   
 }
 variable "instance_class" {
    description = "The instance class for db"
    type = string
    

   
 }
  variable "engine_version" {
    description = "The engine version for db"
    type = string
    
  }
  variable "subnet_group_name" {
    description = "The subnet group name for db"
    type = string

    
  }
  variable "security_group_ids" {
    description = "The security group ids for db"
    type = list(string)

    
  }