terraform {
  backend "s3" {
    bucket         = "02aug02"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}