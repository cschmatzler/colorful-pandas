variable "s3_access_key" {
  description = "The S3 access key to create a new bucket with"
  type        = string
  sensitive   = true
}

variable "s3_secret_key" {
  description = "The S3 secret key to create a new bucket with"
  type        = string
  sensitive   = true
}

variable "name" {
  description = "The bucket's name"
  type        = string
}
