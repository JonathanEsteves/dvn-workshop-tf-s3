variable "tags" {
  type = map(string)
  default = {
    Project     = "workshop-devops-na-nuvem"
    Environment = "production"
  }
}

variable "auth" {
  type = object({
    assume_role_arn = string
    region          = string
  })

  default = {
    assume_role_arn = "arn:aws:iam::471112511203:role/dvn-workshop-role"
    region          = "us-west-1"
  }
}

variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    internet_gateway_name    = string
    nat_gateway_name         = string
    public_route_table_name  = string
    private_route_table_name = string
    public_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
    private_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
  })
  default = {
    name                     = "workshop-vpc"
    cidr_block               = "10.0.0.0/24"
    internet_gateway_name    = "workshop-internet-gateway"
    nat_gateway_name         = "workshop-nat-gateway"
    public_route_table_name  = "workshop-public-route-table"
    private_route_table_name = "workshop-private-route-table"
    public_subnets = [{
      name                    = "workshop-public-subnet-1a"
      cidr_block              = "10.0.0.0/26"
      availability_zone       = "us-west-1a"
      map_public_ip_on_launch = true
      },
      {
        name                    = "workshop-public-subnet-1c"
        cidr_block              = "10.0.0.64/26"
        availability_zone       = "us-west-1c"
        map_public_ip_on_launch = true
    }]
    private_subnets = [{
      name                    = "workshop-private-subnet-1a"
      cidr_block              = "10.0.0.128/26"
      availability_zone       = "us-west-1a"
      map_public_ip_on_launch = false
      },
      {
        name                    = "workshop-private-subnet-1c"
        cidr_block              = "10.0.0.192/26"
        availability_zone       = "us-west-1c"
        map_public_ip_on_launch = false
    }]
  }
}

variable "remote_backend" {
  type = object({
    s3_bucket                   = string
    dynamodb_table_name         = string
    dynamodb_table_billing_mode = string
    dynamodb_table_hash_key     = string
  })

  default = {
    s3_bucket                   = "workshop-s3-remote-backend-bucket-471112511203"
    dynamodb_table_name         = "workshop-s3-state-locking-table"
    dynamodb_table_billing_mode = "PAY_PER_REQUEST"
    dynamodb_table_hash_key     = "LockID"
  }
}
