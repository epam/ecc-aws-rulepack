variable "region" {
  type        = string
  description = "Region where resources will be created"
  default     = "us-east-1"
}

variable "replication_region" {
  type        = string
  description = "Region for the S3 replication destination bucket"
  default     = "us-west-2"
}
