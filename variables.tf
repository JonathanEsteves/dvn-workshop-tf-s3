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