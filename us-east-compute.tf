module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.8.0"
  providers = {
    aws = aws.us_east_prov
  }

  ami = data.aws_ami.amazon_linux_us_east.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  count = length(var.region["us_east"].azs)
  # key_name = "ephraim-key"

  subnet_id = module.vpc_us_east.public_subnets[count.index]
  vpc_security_group_ids = [module.us_east_ec2_allow_sg.security_group_id]
  tags = {
    Name = "ec2-us-east-instance-${count.index}"
  }
}
