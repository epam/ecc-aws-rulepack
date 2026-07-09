variable "region" {
  type        = string
  description = "Region where resources will be created"
  default     = "us-east-1"
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Whether deletion protection is enabled for ALB"
  default     = true
}
