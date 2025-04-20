provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  region = "us-west-1"
  alias = "us_west"
  
}

provider "aws" {
  region = "us-east-1"
  alias = "us_east_prov"
  
}

# provider "aws" {
#   alias  = "us_east_1"
#   region = "us-east-1"
#   }