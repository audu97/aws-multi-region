module "vpc_us_west" {
  source = "terraform-aws-modules/vpc/aws"

  providers = {
    aws = aws.us_west
  }

  name = "us-west-vpc"
  cidr = var.region["us_west"].vpc_cidr

  azs = var.region["us_west"].azs
  private_subnets = ["10.0.1.0/24","10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    terraform = "true"
    environment = "dev" 
  }
}

module "us_west_rds_allow_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "us-west-rds-allow-sg"
  description = "Allow ec2 access to rds in us-west"
  vpc_id = module.vpc_us_west.vpc_id

  ingress_cidr_blocks = ["10.10.0.0/16"]
  ingress_with_cidr_blocks = [
    {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = "10.0.0.0/16"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "rds-us-west-sg"
  }
}

#us west rds security group for ec2
module "us_west_ec2_allow_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "us-west-ec2-allow-sg"
  description = "Allow ec2 access to rds in us-west"
  vpc_id = module.vpc_us_west.vpc_id

  ingress_cidr_blocks = ["10.10.0.0/16"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"

    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "ec2-us-west-sg"
  }
}

resource "aws_security_group_rule" "allow_us_west_ec2" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = module.us_west_ec2_allow_sg.security_group_id
  source_security_group_id = module.us_west_ec2_allow_sg.security_group_id

  depends_on = [
    module.us_west_rds_allow_sg,
    module.us_west_ec2_allow_sg,
  ]
}
