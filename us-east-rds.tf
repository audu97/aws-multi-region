module "us-east-rds" {
  source = "terraform-aws-modules/rds/aws"
  identifier = "us-east-rds"

  providers = {
    aws = aws.us_east_prov
  }

  engine = "mysql"
  engine_version = "5.7"
  major_engine_version = "5.7"
  family = "mysql5.7"
  storage_encrypted = false
  instance_class = "db.t3.micro"
  allocated_storage = 20
  vpc_security_group_ids = [module.us_east_rds_allow_sg.security_group_id]
  subnet_ids = module.vpc_us_east.private_subnets
  create_db_subnet_group = true

  db_name = "Blogdb"
  username = "ephraim"
  port = 3306
  password = "123456789" 

  multi_az = false

}

