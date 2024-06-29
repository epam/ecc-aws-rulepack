resource "aws_ecs_cluster" "this" {
  name = "${module.naming.resource_prefix.ecs}"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

data "aws_ecs_task_definition" "this" {
  task_definition = aws_ecs_task_definition.this.family
  depends_on = [aws_ecs_task_definition.this]
}

resource "aws_ecs_task_definition" "this" {
    family                   = "service"
    network_mode             = "host"
    requires_compatibilities = ["EC2"]
    pid_mode                 = "task"
    container_definitions    = <<DEFINITION
[
  {
    "name": "web",
    "image": "nginx",
    "cpu": 2,
    "memory": 10
  }
]
DEFINITION
}

resource "aws_ecs_service" "this" {
  name             = "${module.naming.resource_prefix.ecs_service}"
  cluster          = aws_ecs_cluster.this.id
  task_definition  = aws_ecs_task_definition.this.arn
  desired_count    = 1

  ordered_placement_strategy {
    type  = "random"
  }
}
