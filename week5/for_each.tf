provider "aws" {
  region = "ap-northeast-2"
}

variable "bucket-names" {
  description = "A list of names"
  type        = list(string)
  default     = ["mybucket1-1103", "mybucket2-1103", "mybucket3-1103"]
}

resource "aws_s3_bucket" "mys3buckets" {
  for_each = toset(var.bucket-names)
  bucket   = each.value
}
