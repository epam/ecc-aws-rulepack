resource "aws_ecs_cluster" "this" {
  name = "ecs_cluster_495_green"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "495_ecs_task_definition_green"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  pid_mode                 = "task"
  container_definitions    = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memory": 5,
    "essential": true
  }
]
DEFINITION
}


resource "aws_ecs_service" "this" {
  name            = "495_ecs_service_green"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
}
