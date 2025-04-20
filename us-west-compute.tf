
module "us-west-ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.8.0"

  ami = data.aws_ami.amazon_linux_us_west.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  count = length(var.region["us_west"].azs)
  # key_name = "ephraim-key"

  subnet_id = module.vpc_us_west.public_subnets[count.index]
  vpc_security_group_ids = [module.us_west_ec2_allow_sg.security_group_id]

  tags = {
    Name = "ec2-us-west-instance-${count.index}"
  }
}