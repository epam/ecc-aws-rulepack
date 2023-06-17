resource "aws_ecs_cluster" "this" {
  name = "ecc-aws-955-ecs_task_definitions_green1"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "955_ecs_task_definition_green1"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  container_definitions    = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memory": 5,
    "essential": true,
    "privileged": true,
    "user": "test" 
  }
]
DEFINITION
}

resource "aws_ecs_service" "this" {
  name            = "955_ecs_service_green1"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
}