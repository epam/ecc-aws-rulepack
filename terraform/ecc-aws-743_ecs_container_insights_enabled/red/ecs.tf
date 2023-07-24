resource "aws_ecs_cluster" "this" {
  name = "743_ecs_cluster_red"
  
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}
