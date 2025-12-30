variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "org_enabled" {
  type    = bool
  default = true
}

variable "accounts" {
  description = "minimal accounts to create the organization"
  type = map(object({
    email = string
    name  = string
    ou    = string
  }))
}


