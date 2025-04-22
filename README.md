# AWS Multi-Region Infrastructure with Terraform

This project sets up a **multi-region AWS infrastructure** using Terraform, leveraging the **official AWS Terraform modules**. It includes VPCs, EC2 instances, ALBs with target group attachments, and RDS—all split across `us-east-1` and `us-west-1` regions.

---

## 🌍 Regions Covered
- `us-east-1`
- `us-west-1`

Each region has its own:
- VPC with public and private subnets
- EC2 instances deployed in multiple Availability Zones
- Application Load Balancer (ALB) with target groups
- Private RDS instance (MySQL)

---

## 📁 Project Structure

Files are organized by region instead of using custom modules. For example:
- `us-east-network.tf`
- `us-east-compute.tf`
- `us-east-rds.tf`
- `us-east-lb.tf`
- `us-west-network.tf`, etc.

There is **no custom module folder**. Instead, this project uses **Terraform's official AWS modules** such as:
- `terraform-aws-modules/vpc/aws`
- `terraform-aws-modules/ec2-instance/aws`
- `terraform-aws-modules/alb/aws`
- `terraform-aws-modules/rds/aws`

---

## 🔧 What `main.tf` Does

The `main.tf` file defines provider aliases and fetches the latest **Amazon Linux 2 AMI** for each region using the `aws_ami` data source:

```hcl
data "aws_ami" "amazon_linux_us_east" {
  most_recent = true
  provider    = aws.us_east_prov
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_ami" "amazon_linux_us_west" {
  most_recent = true
  provider    = aws.us_west
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}
```

This ensures the EC2 instances are launched with the latest Amazon Linux 2 image.

---

## 🛠️ Key Features
- ✅ VPCs in both `us-east-1` and `us-west-1` using `terraform-aws-modules/vpc/aws`
- ✅ EC2 instances in public subnets, spread across AZs using `count = length(var.region[...].azs)`
- ✅ ALBs with listeners, target groups and `additional_target_group_attachments`
- ✅ Private RDS instances in private subnets
- ✅ Provider aliasing to handle resources in each region

---

## 📐 Architecture Diagram


![multi-region--with-rds](https://github.com/user-attachments/assets/cc4dfa3a-5bba-42d7-b2a8-1ca39db219ec)


> Note: EC2 instances use `count` to span multiple AZs and are attached to ALBs using dynamically created attachments.

---

## 📦 Requirements
- Terraform >= 1.5
- AWS CLI configured

---

## 🚀 Deploy
```bash
terraform init
terraform plan
terraform apply
```

---

## 🧼 Cleanup
```bash
terraform destroy
```

