variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "sungwon-int-200421"
}

variable "prefix" {
  type        = string
  description = "Prefix applied to service account names."
  default     = "terraform"
}


variable "bucket_name"{
  type	      = string
  description = "The bucket name of gcs"
  default     = "my-terraform-gcs-bucket"
}
