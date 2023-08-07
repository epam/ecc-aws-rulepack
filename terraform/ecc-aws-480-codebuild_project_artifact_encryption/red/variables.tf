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
  description = "GitHub repository"
}

variable "access_key" {
  type        = string
  description = "Your access key"
}

variable "secret_key" {
  type        = string
  description = "Your secret key"
}