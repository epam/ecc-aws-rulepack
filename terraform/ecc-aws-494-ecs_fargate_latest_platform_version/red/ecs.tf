resource "aws_ecs_cluster" "this" {
  name = "494_ecs_cluster_red"
}

data "aws_ecs_task_definition" "this" {
  task_definition = aws_ecs_task_definition.this.family
  depends_on      = [aws_ecs_task_definition.this]
}

resource "aws_ecs_task_definition" "this" {
    family                   = "service"
    cpu                      = 256
    memory                   = 512
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
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
  name             = "494_ecs_service_red"
  launch_type      = "FARGATE"
  cluster          = aws_ecs_cluster.this.id
  task_definition  = aws_ecs_task_definition.this.arn
  platform_version = "1.3.0"
  desired_count    = 1

  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    assign_public_ip = true
  }
}
