resource "aws_ecs_cluster" "this" {
  name = "ecs_cluster_745_red"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "745_ecs_task_definition_red"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  pid_mode                 = "task"
  container_definitions    = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memoryReservation": 5,
    "essential": true
  }
]
DEFINITION
}

resource "aws_ecs_service" "this" {
  name            = "745_ecs_service_red"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
}
