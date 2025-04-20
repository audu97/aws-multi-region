module "us-east-loadbalancer" {
    source = "terraform-aws-modules/alb/aws"

    providers = {
        aws = aws.us_east_prov
    }
    
    name               = "us-east-alb"
    internal          = false
    vpc_id = module.vpc_us_east.vpc_id
    subnets = module.vpc_us_east.public_subnets
    

    security_group_ingress_rules = {
        all_http = {
            from_port   = 80
            to_port     = 80
            ip_protocol    = "tcp"
            description = "HTTP web traffic"
            cidr_ipv4 = "0.0.0.0/0"
        }

        all_https = {
            from_port   = 443
            to_port     = 443
            ip_protocol = "tcp"
            description = "HTTPS web traffic"
            cidr_ipv4 = "0.0.0.0/0"
        }
    }
    security_group_egress_rules = {
        all = {
            ip_protocol = "-1"
            cidr_ipv4 = "10.0.0.0/16"
        }
            
    }

    listeners = {
        http = {
            port     = 80
            protocol = "HTTP"
            forward = {
                port     = 443
                target_group_key = "us-east-instances"
                
            }
        }
    }

    target_groups = {
        us-east-instances ={
            name_prefix = "us-ea-"
            protocol = "HTTP"
            port = 80
            target_type = "instance"
            create_attachment = false
            # target_id = module.ec2-instance[0].id
        }

    
    }

    additional_target_group_attachments = {

        # for_each = module.ec2-instance

        # target_group_key = "us-east-instances"
        # target_type      = "instance"
        # target_id        = each.value.id
        # port             = 80  

        for idx in range(length(var.region["us_east"].azs)): "us-east-${idx}" => {
            target_group_key = "us-east-instances"
            target_type      = "instance"
            target_id        = module.ec2-instance[idx].id
            port             = 80
        
        }
        
        # ex-instance-other = {
        #     target_group_key = "us-east-instances"
        #     target_type      = "instance"
        #     target_id        = module.ec2-instance.id
        #     port             = "80"
        # }
    }

}

# resource "aws_lb_target_group_attachment" "us-east-attachment" {
#     provider = aws.us_east_prov
#     count = length(module.ec2-instance)
#     target_group_arn = module.us-east-loadbalancer.target_groups["us-east-instances"].arn
#     target_id        = module.ec2-instance[count.index].id
#     port             = 80
  
# }