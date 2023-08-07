resource "aws_ecs_cluster" "this" {
  name = "521-ecs-cluster-red"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "521_ecs_task_definition_red"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  container_definitions    = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memory": 5,
    "ReadonlyRootFilesystem": false
  }
]
DEFINITION
}

resource "aws_ecs_service" "this" {
  name            = "521_ecs_service_red"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
}
