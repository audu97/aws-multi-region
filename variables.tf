variable "region" {
    type = map(object({
        region_code = string
        azs         = list(string)
        vpc_cidr = string
    }))

    default = {
      "us_west" = {
            region_code = "us-west-1"
            azs         = ["us-west-1a", "us-west-1b"]  
            vpc_cidr    = "10.0.0.0/16"
        }

        "us_east" = {
            region_code = "us-east-1"
            azs         = ["us-east-1a", "us-east-1b"]
            vpc_cidr    = "10.0.0.0/16"
        }
    }

  
}