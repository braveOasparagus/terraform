variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["sw", "ey"]
}

variable "egress"  {
  type = map(object({
    from_port = number
    to_port   = number
  }))

  default = { 
    http = {
      from_port = 80
      to_port   = 80
    },
    https = {
      from_port = 443
      to_port   = 443
    },
    ssh = {
      from_port = 22
      to_port   = 22
    }
  }
}
