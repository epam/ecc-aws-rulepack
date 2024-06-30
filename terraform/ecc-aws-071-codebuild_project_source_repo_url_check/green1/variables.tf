variable "default-region" {
  type        = string
  description = "Default region for resources will be created"
}

variable "profile" {
  type        = string
  description = "Profile name configured before running apply"
}

variable "github_location" {
  type        = string
  default     = "https://github.com/cloud-custodian/cloud-custodian"
}

variable "bitbucket_location" {
  type        = string
  default     = "https://bitbucket.org/test/test"
}