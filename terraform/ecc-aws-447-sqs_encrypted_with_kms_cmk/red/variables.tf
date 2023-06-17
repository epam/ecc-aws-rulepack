variable "default-region" {
  type        = string
  default     = "eu-central-1"
  description = "Default region for resources will be created"
}

variable "profile" {
  type        = string
  default     = "c7n"
  description = "Profile name configured before running apply"
}
