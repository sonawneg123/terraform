module "database" {
  source = "./modules/rds"

  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  allocated_storage   = var.allocated_storage
  instance_class      = var.instance_class
  engine_version      = var.engine_version
  subnet_group_name   = var.subnet_group_name
  security_group_ids  = var.security_group_ids
}