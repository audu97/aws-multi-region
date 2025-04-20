data "aws_ami" "amazon_linux_us_east" {
  most_recent = true
  provider = aws.us_east_prov
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_ami" "amazon_linux_us_west" {
  most_recent = true
  provider = aws.us_west
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}