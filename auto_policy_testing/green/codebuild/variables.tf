variable "region" {
  type        = string
  description = "Region where resources will be created"
  default     = "us-east-1"
}

variable "remote_state_region" {
  type        = string
  description = "Region where resources will be created"
  default     = "us-east-1"
}

variable "remote_state_bucket" {
  type        = string
}

variable "remote_state_key" {
  type        = string
}

variable "github_location" {
  type        = string
  default     = "https://github.com/cloud-custodian/cloud-custodian"
}

variable "bitbucket_location" {
  type        = string
  default     = "https://bitbucket.org/ansible/ansible"
}