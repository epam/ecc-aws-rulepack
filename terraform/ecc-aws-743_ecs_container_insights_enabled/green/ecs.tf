resource "aws_ecs_cluster" "this" {
  name = "743_ecs_cluster_green"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}