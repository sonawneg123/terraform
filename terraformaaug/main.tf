provider "aws" {
  region = "us-east-1"
}
module "rds" {
    source = "./rds"
    db_name = "mydb"
    db_username = "admin"
    db_password = "password123"
   
}