resource "aws_ecs_cluster" "this" {
  name = "493_ecs_cluster_red"
  
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}
