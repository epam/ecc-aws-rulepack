variable "default-region" {
  type        = string
  description = "Default region for resources will be created"
}

variable "profile" {
  type        = string
  description = "Profile name configured before running apply"
}

locals {
  cluster_name = "110_ecs_cluster_red"
  volume_name  = "110_service-ebs-volume_red"
}