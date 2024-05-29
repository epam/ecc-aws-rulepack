variable "region" {
  type        = string
  description = "Region where resources will be created"
  default     = "us-east-1"
}

variable "github_location" {
  type        = string
  default     = "https://github.com/mitchellh/packer.git"
}

variable "bitbucket_location" {
  type        = string
  default     = "https://bitbucket.org/ansible/ansible"
}

